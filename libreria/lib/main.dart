import 'package:flutter/material.dart';
import 'package:libreria/FavoritesPage.dart';
import 'package:libreria/HomePage.dart';
import 'package:libreria/LoginPage.dart';
import 'package:libreria/OpzionsPage.dart';
import 'package:libreria/SearchPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//cambiare icona
//tinderCard
//honeyBeeDb
void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //rimozione del banner di debug
      debugShowCheckedModeBanner: false,
      //title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //pagina principale che viene invocata appena viene aperta l'applicazione
      home: LoginPage(),
      //possibili rotte con correlate pagine
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
