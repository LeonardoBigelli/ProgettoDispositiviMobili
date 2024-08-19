import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  void _startSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  void _goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scegli un\'opzione')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _startSearch(context),
              child: Text('Inizia una Ricerca'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToHome(context),
              child: Text('Vai alla Home'),
            ),
          ],
        ),
      ),
    );
  }
}
