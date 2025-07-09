import 'dart:convert';
import 'package:demoapp/constants.dart';
import 'package:demoapp/models/order.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static Future<List<Order>> fetchOrders(int userId) async {
    final url = Uri.parse('$BASE_URL/orders/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }
}
