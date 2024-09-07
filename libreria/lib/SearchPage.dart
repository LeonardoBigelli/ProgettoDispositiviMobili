import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libreria/BookDetailsPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//NON SONO SICURO CHE SERVA LO STATO (DA RIVEDERE), per ora serve (lo stato) per capire se ho caricato i libri o meno
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
        //sezione che precede il titolo, per tornare alla pagina precedente
        /* leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
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
                    //ListView per mostrare tutti i libri caricati
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
                              : const Icon(Icons.book),
                          title: Text(title),
                          subtitle: Text(author),
                          onTap: () {
                            // Naviga alla pagina dei dettagli del libro
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsPage(
                                  title: title,
                                  author: author,
                                  coverUrl:
                                      'https://covers.openlibrary.org/b/id/${book['cover_i']}-M.jpg',
                                  description: book['description'] ?? '',
                                ),
                              ),
                            );
                          },
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
