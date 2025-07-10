import 'package:demoapp/screens/qr_screen.dart'; // Add this import
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback? onOrderDelivered;

  const OrderCard({Key? key, required this.order, this.onOrderDelivered})
    : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QRScreen(
                        order: _order,
                        onOrderDelivered: widget.onOrderDelivered,
                      ),
                    ),
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
