import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mydormitory/models/login_response.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.61.229:8000/api'; // ip local

  static Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN BODY: ${response.body}');

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY: ${response.body}');

    Map<String, dynamic>? data;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        data = decoded;
      }
    } catch (e) {
      debugPrint('Failed to decode JSON: $e');
    }

    if (response.statusCode == 200 && data != null) {
      return LoginResponse.fromJson(data);
    }

    // fallback jika error HTTP
    return LoginResponse(
      success: false,
      message: data != null && data['message'] != null
          ? data['message'].toString()
          : 'Server error (${response.statusCode})',
    );
  }
}
