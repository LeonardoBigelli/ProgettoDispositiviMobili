import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/UserCredentials.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    void login() {
      final provider = ref.read(userProvider.notifier);
      provider.login(
        usernameController.text,
        passwordController.text,
      );

      if (provider.state?.validate() == true) {
        Navigator.pushReplacementNamed(context, '/options');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nome utente o password non validi')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 100, color: Colors.white),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Nome utente',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
