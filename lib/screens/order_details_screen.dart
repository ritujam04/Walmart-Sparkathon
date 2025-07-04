import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/champion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<Champion> champions = [];
  Champion? selectedChampion;
  bool isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    fetchChampions();
  }

  Future<void> fetchChampions() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.3:8000/champions'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        champions = (data as List)
            .map((json) => Champion.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> placeOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (selectedChampion == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a champion")));
      return;
    }

    setState(() => isPlacingOrder = true);

    final orderPayload = {
      'user_id': 1, // Replace with actual user ID
      'champion_id': selectedChampion!.id,
      'total_amount': cart.totalPrice,
      'order_items': cart.items
          .map(
            (item) => {
              'product_id': item.id,
              'name': item.name,
              'quantity': item.quantity,
              'unit_price': item.price,
              'subtotal': item.quantity * item.price,
            },
          )
          .toList(),
    };

    final response = await http.post(
      Uri.parse('http://192.168.1.3:8000/place-order'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderPayload),
    );

    setState(() => isPlacingOrder = false);

    if (response.statusCode == 200) {
      cart.clearCart();
      Navigator.pushReplacementNamed(context, '/order-confirmation');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Order placement failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Your Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Champion>(
              decoration: const InputDecoration(
                labelText: 'Choose Champion',
                border: OutlineInputBorder(),
              ),
              value: selectedChampion,
              items: champions
                  .map(
                    (champ) =>
                        DropdownMenuItem(value: champ, child: Text(champ.name)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedChampion = value),
            ),
            const SizedBox(height: 24),

            // Total Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.green),
                title: const Text('Total Amount'),
                trailing: Text(
                  '₹${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isPlacingOrder
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.shopping_cart_checkout),
                label: Text(
                  isPlacingOrder ? 'Placing Order...' : 'Place Order',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isPlacingOrder ? null : placeOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
