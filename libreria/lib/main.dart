import 'package:flutter/material.dart';
import 'package:libreria/FavoritesPage.dart';
import 'package:libreria/HomePage.dart';
import 'package:libreria/LoginPage.dart';
import 'package:libreria/OpzionsPage.dart';
import 'package:libreria/SearchPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/options': (context) => OptionsPage(),
        '/search': (context) => SearchPage(),
        '/favorites': (context) => FavoritesPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

/*class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Benvenuto nella Home Page!')),
    );
  }
}*/
