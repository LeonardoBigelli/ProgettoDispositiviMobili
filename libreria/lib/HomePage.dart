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
      SnackBar(content: Text('Libro aggiunto ai preferiti')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bestSellersAsyncValue = ref.watch(bestSellerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bestseller'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: bestSellersAsyncValue.when(
        data: (books) {
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookItemEx(
                book: [
                  book['title'],
                  book['author'],
                  book['book_image'] ?? '',
                  book['description'] ?? '',
                ],
                onSave: () {
                  // Riverpod per lo stato, aggiungere i libri
                  _addBookToFavorites(
                      book['title'], book['author'], book['book_image']);
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Failed to load data: $error')),
      ),
    );
  }
}

// Widget personalizzato per mostrare le informazioni del libro con possibilità di espansione
class BookItemEx extends StatelessWidget {
  final List<String> book; // [title, author, coverUrl, description]
  final VoidCallback? onSave;

  const BookItemEx({Key? key, required this.book, this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: book[2].isNotEmpty
          ? Image.network(
              book[2],
              width: 50,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                // Questo widget viene visualizzato se c'è un errore durante il caricamento dell'immagine
                return Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey,
                  child: Icon(
                      Icons.broken_image), // Icona di immagine non caricata
                );
              },
            )
          : Container(
              width: 50,
              height: 75,
              color: Colors.grey,
              child: Icon(Icons.book),
            ),
      title: Text(book[0]),
      subtitle: Text(book[1]),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(book[3]), // Descrizione del libro
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: onSave,
            child: Text('Aggiungi ai preferiti'),
          ),
        ),
      ],
    );
  }
}
