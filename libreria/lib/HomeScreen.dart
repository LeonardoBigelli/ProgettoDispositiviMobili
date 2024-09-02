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
  int _selectedIndex = 0;

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
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
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
