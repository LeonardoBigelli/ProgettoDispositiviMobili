import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String title;
  final String author;
  final String coverUrl;
  final VoidCallback onRemove; // Callback per la rimozione del libro

  BookItem({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onRemove();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title rimosso dai preferiti')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: coverUrl.isNotEmpty
            ? Image.network(coverUrl, width: 50, fit: BoxFit.cover)
            : const Icon(Icons.book),
        title: Text(title),
        subtitle: Text(author),
      ),
    );
  }
}
