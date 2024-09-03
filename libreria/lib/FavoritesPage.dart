import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/UserCredentials.dart';
import 'bookItem.dart';

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteBooks = ref.watch(userProvider)?.favoriteBooks ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Libri Preferiti'),
        backgroundColor: Colors.indigo,
        /* leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
      ),
      body: favoriteBooks.isEmpty
          ? const Center(child: Text('Nessun libro preferito'))
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return BookItem(
                  title: book[0],
                  author: book[1],
                  coverUrl: book[2],
                  onRemove: () {
                    // Rimuovi il libro dalla lista dei preferiti
                    ref.read(userProvider.notifier).removeFavoriteBook(book[0]);
                  },
                );
              },
            ),
    );
  }
}
