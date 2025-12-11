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
    final isFavorite = ref.watch(
      userLibraryProvider.select((lib) => lib.favorites.contains(book.id)),
    );

    return ListTile(
      title: Text(book.title),
      subtitle: Text('${book.author} • ${book.genre}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(book.rating?.toStringAsFixed(1) ?? '-'),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              ref.read(userLibraryProvider.notifier).toggleFavorite(book.id);
            },
          ),
        ],
      ),
      leading: const Icon(Icons.book),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
        );
      },
    );
  }
}
