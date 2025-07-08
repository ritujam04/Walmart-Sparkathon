import 'package:demoapp/constants.dart';
import 'package:demoapp/screens/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderTrackingScreen extends StatefulWidget {
  final int userId;
  const OrderTrackingScreen({required this.userId, super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Map<String, dynamic>? order;

  Future<void> fetchOrder() async {
    final response = await http.get(
      Uri.parse("$BASE_URL/user-orders/${widget.userId}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => order = data["order"]);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return const Scaffold(
        body: Center(child: Text("No current orders found")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Track Your Order")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order!['id']}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Status: ${order!['order_status']}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            if (order!['order_status'] == 'delivered_to_champion')
              ElevatedButton.icon(
                icon: const Icon(Icons.qr_code),
                label: const Text("Receive Order"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderQRScreen(qrToken: order!['qr_token']),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
