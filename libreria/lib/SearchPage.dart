import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:libreria/BookItem.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
        SnackBar(content: Text('Errore nella ricerca')),
      );
    }
  }

  void _removeBook(int index) {
    setState(() {
      _books.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Libro rimosso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ricerca Libri')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cerca un libro',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchBooks,
                ),
              ),
              onSubmitted: (_) => _searchBooks(),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _books.isEmpty
                    ? Text('Nessun risultato trovato')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _books.length,
                          itemBuilder: (context, index) {
                            final book = _books[index];
                            final coverUrl = book['cover_i'] != null
                                ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-S.jpg'
                                : '';

                            return BookItem(
                              title: book['title'] ?? 'Senza Titolo',
                              author: book['author_name']?.join(', ') ??
                                  'Autore sconosciuto',
                              coverUrl: coverUrl,
                              onDismissed: () => _removeBook(index),
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
