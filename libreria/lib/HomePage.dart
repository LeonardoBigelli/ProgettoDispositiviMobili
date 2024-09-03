import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:libreria/BookDetailsPage.dart';

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

// Definisce il provider per i libri più venduti
final mostSoldBooksProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await http.get(Uri.parse(
      'https://api.nytimes.com/svc/books/v3/lists/current/hardcover-nonfiction.json?api-key=AguAOknUFxVqy4VNKquO7Z2q45pnMlko'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results']['books'];
  } else {
    throw Exception('Failed to load most sold books');
  }
});

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// HomePage che mostra i bestseller e i libri più venduti
class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final bestSellersAsyncValue = ref.watch(bestSellerProvider);
    final mostSoldBooksAsyncValue = ref.watch(mostSoldBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // allinea gli elementi a sinistra
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Bestseller', // Titolo per la sezione dei bestseller
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Lista orizzontale delle copertine dei libri
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.3, // Occupa una parte dello schermo
            child: bestSellersAsyncValue.when(
              data: (books) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return GestureDetector(
                      onTap: () {
                        // Naviga alla pagina dei dettagli del libro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                              title: book['title'],
                              author: book['author'],
                              coverUrl: book['book_image'] ?? '',
                              description: book['description'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AspectRatio(
                          aspectRatio: 2 /
                              3, // Imposta un rapporto fisso per le copertine dei libri
                          child: BookCoverWidget(
                            imageUrl: book['book_image'] ?? '',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Failed to load data: $error')),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              'I Più Venduti', // Titolo per la sezione dei più venduti
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Lista verticale per i libri più venduti
          Expanded(
            child: mostSoldBooksAsyncValue.when(
              data: (books) {
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 75,
                        child: Image.network(
                          book['book_image'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                      title: Text(book['title']),
                      onTap: () {
                        // Naviga alla pagina dei dettagli del libro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                              title: book['title'],
                              author: book['author'],
                              coverUrl: book['book_image'] ?? '',
                              description: book['description'] ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Failed to load data: $error')),
            ),
          ),
        ],
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
    return ClipRRect(
      // Clip con bordi arrotondati per migliorare l'aspetto
      borderRadius: BorderRadius.circular(8.0),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit
                  .cover, // Assicurati che l'immagine riempia tutto lo spazio disponibile
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image),
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
