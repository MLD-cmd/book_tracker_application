import 'package:flutter/material.dart';
import '../../models/book.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.author} • ${book.genre}'),
      trailing: Text(book.rating?.toStringAsFixed(1) ?? '-'),
      leading: const Icon(Icons.book),
      onTap: () {
        // Navigate to book detail later
      },
    );
  }
}