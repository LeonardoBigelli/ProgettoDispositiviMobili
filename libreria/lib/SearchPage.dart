import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/BookDetailsPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends ConsumerStatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  List _books = [];
  bool _isLoading = false;

  void _searchBooks() async {
    setState(() {
      _isLoading = true;
    });

    final query = _searchController.text;
    final url = 'https://openlibrary.org/search.json?q=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _books = data['docs'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore nella ricerca')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerca Libri', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Cerca un libro',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _searchBooks(),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            for (var book in _books)
              Card(
                elevation: 4, // Ombra della Card
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0), // Spazio verticale tra le Card
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0), // Padding interno
                  leading: book['cover_i'] != null
                      ? Image.network(
                          'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg',
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              color: Colors.grey,
                              width: 50,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        )
                      : const Icon(Icons.book),
                  title: Text(
                    book['title'] ?? 'Titolo non disponibile',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(book['author_name']?.join(', ') ??
                      'Autore non disponibile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(
                          title: book['title'] ?? 'Titolo non disponibile',
                          author: book['author_name']?.join(', ') ??
                              'Autore non disponibile',
                          coverUrl: book['cover_i'] != null
                              ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg'
                              : '',
                          description: book['description'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }
}
