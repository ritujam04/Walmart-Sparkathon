import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Order _order;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling(int userId) {
    _pollingTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      final provider = Provider.of<OrderProvider>(context, listen: false);
      await provider.fetchOrders(userId);
      final updatedOrder = provider.getOrderById(_order.id);
      if (updatedOrder != null &&
          updatedOrder.orderStatus == 'successfully delivered') {
        timer.cancel();
        Navigator.of(context).pop();
        setState(() {
          _order = updatedOrder;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isQRReady = _order.orderStatus == 'delivered_to_champion';
    bool isDelivered = _order.orderStatus == 'successfully delivered';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${_order.id}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Total: ₹${_order.totalAmount.toStringAsFixed(2)}"),
            Text("Address: ${_order.deliveryAddress}"),
            Text("Date: ${_order.createdAt}"),
            const SizedBox(height: 12),

            if (isQRReady)
              ElevatedButton(
                onPressed: () {
                  final userId = Provider.of<OrderProvider>(
                    context,
                    listen: false,
                  ).orders.firstWhere((o) => o.id == _order.id).id;
                  showDialog(
                    context: context,
                    builder: (context) {
                      _startPolling(userId);
                      return AlertDialog(
                        title: const Text('Show this QR to Champion'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Scan this QR code to receive your order:',
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: QrImageView(
                                  data: _order.qrToken,
                                  version: QrVersions.auto,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Only valid for your assigned Champion.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _pollingTimer?.cancel();
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Show QR to Champion'),
              )
            else if (isDelivered)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Successfully Delivered',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Waiting for Delivery'),
              ),
          ],
        ),
      ),
    );
  }
}
