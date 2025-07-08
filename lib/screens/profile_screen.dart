import 'package:demoapp/constants.dart';
import 'package:demoapp/providers/order_provider.dart';
import 'package:demoapp/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/order.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Order> orders = [];
  bool isLoading = true;

  Future<void> fetchOrders() async {
    final userId = 1; // TODO: replace with actual user ID from auth
    final url = Uri.parse('$BASE_URL/orders/user/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        orders = data.map((json) => Order.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to fetch orders")));
    }
  }

  @override
  void initState() {
    super.initState();
    final userId = 1;
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    final userId = 1;

    return RefreshIndicator(
      onRefresh: () => orderProvider.fetchOrders(userId), // 🌀 Pull to refresh
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}
