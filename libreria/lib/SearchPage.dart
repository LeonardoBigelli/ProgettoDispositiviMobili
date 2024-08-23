import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/UserCredentials.dart';
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

  void _addBookToFavorites(String title, String author, String coverUrl) {
    final provider = ref.read(userProvider.notifier);
    provider.addFavoriteBook(title, author, coverUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Libro aggiunto ai preferiti')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cerca Libri'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cerca un libro',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchBooks(),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        final title = book['title'] ?? 'Titolo non disponibile';
                        final author = book['author_name']?.join(', ') ??
                            'Autore non disponibile';
                        final coverUrl = book['cover_i'] != null
                            ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg'
                            : '';

                        return ListTile(
                          leading: coverUrl.isNotEmpty
                              ? Image.network(coverUrl,
                                  width: 50, fit: BoxFit.cover)
                              : Icon(Icons.book),
                          title: Text(title),
                          subtitle: Text(author),
                          trailing: IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () =>
                                _addBookToFavorites(title, author, coverUrl),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
