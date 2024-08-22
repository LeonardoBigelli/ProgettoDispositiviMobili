import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/UserCredentials.dart';

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteBooks = ref.watch(userProvider)?.favoriteBooks ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Libri Preferiti'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('Nessun libro preferito'))
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return ListTile(
                  leading: book[2]!.isNotEmpty
                      ? Image.network(book[2]! as String,
                          width: 50, fit: BoxFit.cover)
                      : Icon(Icons.book),
                  title: Text(book[0]! as String),
                  subtitle: Text(book[1]! as String),
                );
              },
            ),
    );
  }
}
