import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'data': body};
    } else {
      return {'success': false, 'message': body['detail'] ?? 'Unknown error'};
    }
  }
}
