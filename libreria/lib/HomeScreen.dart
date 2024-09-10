//import delle classi impiegate
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/FavoritesPage.dart';
import 'package:libreria/HomePage.dart';
import 'package:libreria/SearchPage.dart';
import 'package:libreria/UserPage.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //indice selezionato che si riferisce alla classe da dover invocare
  int _selectedIndex = 0;

  //lista contenente le classi rappresentanti le varie pagine
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Ricerca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Preferiti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Utente',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            Colors.pinkAccent, // Colore dell'elemento selezionato
        unselectedItemColor:
            Colors.white70, // Colore degli elementi non selezionati
        backgroundColor:
            Colors.indigo, // Colore di sfondo della BottomNavigationBar
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Tipo di barra di navigazione
      ),
    );
  }
}
