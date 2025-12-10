import 'package:flutter/material.dart';
import '/models/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${book.author}'),
            Text('Genre: ${book.genre}'),
            Text('Pages: ${book.pages}'),
            Text('Rating: ${book.rating ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
