import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/book_providers.dart';
import 'book_list_item.dart';

class BookListPage extends ConsumerWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(filteredBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tracker'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookListItem(book: books[index]);
        },
      ),
    );
  }
}