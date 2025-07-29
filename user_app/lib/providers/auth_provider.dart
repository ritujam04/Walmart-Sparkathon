import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  User? _user;

  User? get user => _user;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      print(response.body);
      print('Login response: ${response.body}');
      print('Status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        _user = User.fromJson(data);
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = data['message'] ?? 'Login failed';
      }
    } catch (e) {
      print(e);
      errorMessage = 'An error occurred';
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
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

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _user = User.fromJson(data); // Update User model if needed
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = data['message'] ?? 'Signup failed';
      }
    } catch (e) {
      errorMessage = 'An error occurred';
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
