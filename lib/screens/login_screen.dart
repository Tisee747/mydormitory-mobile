import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:mydormitory/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String _message = '';

  void _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    debugPrint("=== DEBUG DATA LOGIN ===");
    debugPrint("Email dikirim: '$email'"); // Perhatikan tanda kutipnya
    debugPrint(
      "Password dikirim: '$password'",
    ); // Apakah ada spasi di dalam kutip?
    debugPrint("========================");

    try {
      final response = await ApiService.login(email, password).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
            "Koneksi Timeout! Server tidak merespon dalam 15 detik.",
          );
        },
      );

      if (mounted) {
        setState(() {
          _loading = false;

          if (response.success && response.user != null) {
            _message = 'Login berhasil!';

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(user: response.user!),
              ),
            );
          } else {
            _message = response.message ?? 'Login gagal';
          }
        });
      }
    } catch (e) {
      debugPrint("ERROR LOGIN: $e"); // Cek terminal

      if (mounted) {
        setState(() {
          _loading = false;
          _message = 'Gagal terhubung: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login Penghuni Asrama',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? 'Masukkan email' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? 'Masukkan password' : null,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _loading ? null : _doLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  Text(_message, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
