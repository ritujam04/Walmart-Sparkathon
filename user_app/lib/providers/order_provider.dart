import 'package:demoapp/providers/order_services.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? error;

  List<Order> get orders => _orders;
  bool get loading => _isLoading;

  Future<void> fetchOrders(int? userId) async {
    if (userId == null) {
      error = "User ID is null";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _orders = await OrderService.fetchOrders(userId);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOrders(int userId) async {
    await fetchOrders(userId);
  }

  void clearOrders() {
    _orders = [];
    notifyListeners();
  }

  Order? getOrderById(int id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
