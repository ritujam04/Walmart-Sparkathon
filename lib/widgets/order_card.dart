import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/order.dart';

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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Show this QR to Champion'),
                          content: SizedBox(
                            width:
                                MediaQuery.of(context).size.width *
                                0.8, // constrain width
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Scan this QR code to receive your order:',
                                  ),
                                  const SizedBox(height: 16),
                                  QrImageView(
                                    data: order.qrToken,
                                    version: QrVersions.auto,
                                    size: 200.0,
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
                          ),

                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
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
