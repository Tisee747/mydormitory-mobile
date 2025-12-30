import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.244.141:8000/api';

  static Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print('LOGIN STATUS: ${response.statusCode}');
    print('LOGIN BODY: ${response.body}');


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return User.fromJson(data['user']);
      }
    }
    return null;
  }
}
