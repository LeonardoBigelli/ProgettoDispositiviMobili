//import impiegati
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/UserCredentials.dart';
import 'bookItem.dart';

//classe che permette la visualizzazione della pagine dei preferiti.
class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteBooks = ref.watch(userProvider)?.favoriteBooks ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Libri Preferiti',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: favoriteBooks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Nessun libro preferito',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aggiungi libri alla tua lista di preferiti per visualizzarli qui.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                //widget personalizzato
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
