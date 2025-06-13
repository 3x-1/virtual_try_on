// lib/screens/auth_screen.dart

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthScreen({Key? key, required this.onAuthenticated}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  void _attemptLogin() {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Пожалуйста, введите логин и пароль';
      });
    } else {
      widget.onAuthenticated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход / Регистрация'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(labelText: 'Логин'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _attemptLogin,
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
