import 'package:flutter/material.dart';
import '../models/order.dart';
import '../screens/qr_code_screen.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isQRReady = order.orderStatus == 'delivered_to_champion';

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
              "Order ID: ${order.id}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Status: ${order.orderStatus}"),
            Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
            Text("Address: ${order.deliveryAddress}"),
            Text("Date: ${order.createdAt}"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isQRReady
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderQRScreen(qrToken: order.qrToken),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isQRReady ? Colors.green : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isQRReady ? 'Show QR to Champion' : 'Waiting for Delivery',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
