import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/UserCredentials.dart';

class BookDetailsPage extends ConsumerWidget {
  final String title;
  final String author;
  final String coverUrl;
  final String description;

  const BookDetailsPage({
    Key? key,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
  }) : super(key: key);

  // Funzione per aggiungere il libro tra i preferiti
  void _addBookToFavorites(BuildContext context, WidgetRef ref) {
    final provider = ref.read(userProvider.notifier);
    provider.addFavoriteBook(title, author, coverUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Libro aggiunto ai preferiti')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: coverUrl.isNotEmpty
                  ? Image.network(
                      coverUrl,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          color: Colors.grey,
                          height: 200,
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey,
                      height: 200,
                      child: const Icon(Icons.book),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Autore: $author',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _addBookToFavorites(context, ref),
              child: const Text('Aggiungi ai preferiti'),
            ),
          ],
        ),
      ),
    );
  }
}
