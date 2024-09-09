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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Dismissible(
        key: Key(title),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          onRemove();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title rimosso dai preferiti')),
          );
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 32),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: coverUrl.isNotEmpty
                    ? Image.network(
                        coverUrl,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.book, size: 50),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                author,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
