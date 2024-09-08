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
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: coverUrl.isNotEmpty
                      ? Image.network(
                          coverUrl,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              color: Colors.grey,
                              height: 250,
                              child: const Icon(Icons.broken_image, size: 50),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey,
                          height: 250,
                          child: const Icon(Icons.book, size: 50),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Autore: $author',
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _addBookToFavorites(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  elevation: 5,
                ),
                child: const Text(
                  'Aggiungi ai preferiti',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
