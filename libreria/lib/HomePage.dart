import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:libreria/UserCredentials.dart';

// Definisce il provider per i dati dei libri bestseller
final bestSellerProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await http.get(Uri.parse(
      'https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=AguAOknUFxVqy4VNKquO7Z2q45pnMlko'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results']['books'];
  } else {
    throw Exception('Failed to load bestsellers');
  }
});

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// HomePage che mostra i bestseller
class _HomePageState extends ConsumerState<HomePage> {
  //funzione per aggiungere il libro tra i preferiti
  void _addBookToFavorites(String title, String author, String coverUrl) {
    final provider = ref.read(userProvider.notifier);
    provider.addFavoriteBook(title, author, coverUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Libro aggiunto ai preferiti')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bestSellersAsyncValue = ref.watch(bestSellerProvider);
    int _expandedIndex = -1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bestseller'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: bestSellersAsyncValue.when(
        data: (books) {
          return Column(
            children: [
              // Lista orizzontale delle copertine dei libri
              Container(
                height: MediaQuery.of(context).size.height *
                    0.5, // Occupa metà dello schermo
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle espansione della scheda del libro
                          _expandedIndex = _expandedIndex == index ? -1 : index;
                        });
                      },
                      child: Container(
                        width:
                            160, // Imposta una larghezza fissa per ogni elemento
                        child: Column(
                          children: [
                            BookCoverWidget(
                              imageUrl: book['book_image'] ?? '',
                            ),
                            if (_expandedIndex ==
                                index) // Mostra i dettagli solo se il libro è espanso
                              ExpandedBookDetails(
                                book: [
                                  book['title'],
                                  book['author'],
                                  book['book_image'] ?? '',
                                  book['description'] ?? '',
                                ],
                                onSave: () {
                                  //aggiunta del libro ai preferiti
                                  _addBookToFavorites(book['title'],
                                      book['author'], book['book_image']);
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Lista verticale placeholder per ulteriori implementazioni
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Numero di elementi placeholder
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.book),
                      title: Text('Elemento Placeholder $index'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Failed to load data: $error')),
      ),
    );
  }
}

// Widget personalizzato per mostrare solo la copertina del libro
class BookCoverWidget extends StatelessWidget {
  final String imageUrl;

  const BookCoverWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Larghezza fissa per le copertine
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(
                      Icons.broken_image), // Icona per immagine non caricata
                );
              },
            )
          : Container(
              color: Colors.grey,
              child: const Icon(Icons.book),
            ),
    );
  }
}

// Widget per mostrare i dettagli espansi di un libro
class ExpandedBookDetails extends StatelessWidget {
  final List<String> book; // [title, author, coverUrl, description]
  final VoidCallback? onSave;

  const ExpandedBookDetails({Key? key, required this.book, this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book[0], // Titolo del libro
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Autore: ${book[1]}', // Autore del libro
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              book[3], // Descrizione del libro
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Aggiungi ai preferiti'),
            ),
          ],
        ),
      ),
    );
  }
}
