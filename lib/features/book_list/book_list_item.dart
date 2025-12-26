import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/book.dart';
import '../../providers/book_providers.dart';
import 'book_detail/book_detail_page.dart';

class BookListItem extends ConsumerWidget {
  final Book book;
  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final books = ref.watch(userLibraryProvider);
    final isFavorite = books.firstWhere((b) => b.id == book.id).isFavorite;

    return ListTile(
      leading: const Icon(Icons.book),
      title: Text(book.title),
      subtitle: Text('${book.author} • ${book.genre}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(book.rating?.toStringAsFixed(1) ?? '-'),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              ref
                  .read(userLibraryProvider.notifier)
                  .toggleFavorite(book.id);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailPage(book: book),
          ),
        );
      },
    );
  }
}
