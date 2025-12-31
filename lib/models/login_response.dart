import 'user.dart';

class LoginResponse {
  final bool success;
  final String? role;
  final User? user;
  final Map<String, dynamic>? penghuni;
  final String? message;

  LoginResponse({
    required this.success,
    this.role,
    this.user,
    this.penghuni,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      role: json['role'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      penghuni: json['penghuni'],
      message: json['message'],
    );
  }
}
