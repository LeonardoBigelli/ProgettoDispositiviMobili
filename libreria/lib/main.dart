import 'package:flutter/material.dart';
import 'package:libreria/LoginPage.dart';
import 'package:libreria/OpzionsPage.dart';
import 'package:libreria/SearchPage.dart';

void main() {
  runApp(MyApp());
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
        '/home': (context) => HomePage(),
        '/options': (context) => OptionsPage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Benvenuto nella Home Page!')),
    );
  }
}
/*
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ricerca')),
      body: Center(child: Text('Pagina di Ricerca')),
    );
  }
}*/
