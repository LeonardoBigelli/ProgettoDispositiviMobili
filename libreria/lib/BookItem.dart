import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String title;
  final String author;
  final String coverUrl;
  final VoidCallback onDismissed;

  BookItem({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: coverUrl.isNotEmpty
              ? Image.network(
                  coverUrl,
                  width: 50,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.book),
          title: Text(title),
          subtitle: Text(author),
        ),
      ),
    );
  }
}
