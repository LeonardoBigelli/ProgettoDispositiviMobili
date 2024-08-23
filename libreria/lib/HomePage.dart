import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:libreria/BookItem.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
              return BookItem(
                title: book['title'],
                author: book['author'],
                coverUrl: book['book_image'],
                onRemove: () {},
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
