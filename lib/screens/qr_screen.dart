import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';

class QRScreen extends StatefulWidget {
  final Order order;
  final VoidCallback? onOrderDelivered;

  const QRScreen({Key? key, required this.order, this.onOrderDelivered})
    : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> with TickerProviderStateMixin {
  late Order _currentOrder;
  Timer? _pollingTimer;
  late AnimationController _successAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;

    // Initialize animations
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _successAnimationController.dispose();
    super.dispose();
  }

  void _startPolling() {
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    if (userId == null) return;

    final provider = Provider.of<OrderProvider>(context, listen: false);

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        print(
          '🔄 Polling for order updates... Current status: ${_currentOrder.orderStatus}',
        );

        await provider.fetchOrders(userId);
        final updatedOrder = provider.getOrderById(_currentOrder.id);

        if (!mounted) {
          timer.cancel();
          return;
        }

        if (updatedOrder != null &&
            updatedOrder.orderStatus != _currentOrder.orderStatus) {
          print('✅ Order status updated: ${updatedOrder.orderStatus}');

          setState(() {
            _currentOrder = updatedOrder;
          });

          if (updatedOrder.orderStatus == 'successfully delivered') {
            print('🎉 Order successfully delivered!');
            timer.cancel();
            _successAnimationController.forward();

            // Call the callback
            widget.onOrderDelivered?.call();

            // Auto close after 4 seconds
            Future.delayed(const Duration(seconds: 4), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        }
      } catch (e) {
        print('❌ Error fetching orders: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('QR Code'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _pollingTimer?.cancel();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Order Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Order #${_currentOrder.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ₹${_currentOrder.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Main Content Area
            Expanded(
              child: _currentOrder.orderStatus == 'successfully delivered'
                  ? _buildSuccessView()
                  : _buildQRView(),
            ),

            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: _currentOrder.orderStatus == 'successfully delivered'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _currentOrder.orderStatus == 'successfully delivered'
                      ? Colors.green
                      : Colors.blue,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentOrder.orderStatus == 'successfully delivered')
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    )
                  else
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade600,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    _currentOrder.orderStatus == 'successfully delivered'
                        ? 'Successfully Delivered'
                        : 'Waiting for Champion...',
                    style: TextStyle(
                      color:
                          _currentOrder.orderStatus == 'successfully delivered'
                          ? Colors.green
                          : Colors.blue.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQRView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Show this QR code to your Champion',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // QR Code Container
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: QrImageView(
            data: _currentOrder.qrToken,
            version: QrVersions.auto,
            size: 200,
            backgroundColor: Colors.white,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Only valid for your assigned Champion',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return AnimatedBuilder(
      animation: _successAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Order Successfully Delivered!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for your order!',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'This screen will close automatically',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
