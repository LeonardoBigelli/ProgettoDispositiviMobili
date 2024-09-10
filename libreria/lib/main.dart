//import delle classi impiegate
import 'package:flutter/material.dart';
import 'package:libreria/LoginPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //rimozione del banner di debug
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //pagina di login che viene invocata appena viene aperta l'applicazione
      home: LoginPage(),
    );
  }
}
