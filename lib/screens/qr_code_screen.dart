import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderQRScreen extends StatelessWidget {
  final String qrToken;

  const OrderQRScreen({super.key, required this.qrToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Show QR to Champion')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Scan this QR code to receive your order:'),
            const SizedBox(height: 20),
            QrImageView(data: qrToken, version: QrVersions.auto, size: 250.0),
            const SizedBox(height: 20),
            const Text('Only valid for your assigned Champion.'),
          ],
        ),
      ),
    );
  }
}
