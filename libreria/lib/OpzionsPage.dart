import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Opzioni')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Text('Cerca un libro'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              child: Text('Vedi preferiti'),
            ),
          ],
        ),
      ),
    );
  }
}
