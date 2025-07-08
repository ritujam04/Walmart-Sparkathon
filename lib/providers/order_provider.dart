import 'dart:convert';
import 'package:demoapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> fetchOrders(int userId) async {
    final url = Uri.parse('$BASE_URL/orders/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _orders = data.map((orderJson) => Order.fromJson(orderJson)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print("Order fetch error: $e");
      rethrow;
    }
  }
}
