import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/book.dart';
import '../../providers/book_providers.dart';
import 'book_detail/book_detail_page.dart';

/// BookListItem
/// - Single item nga ginapakita sa book list
/// - Responsible sa:
///   • pag-display sa basic book info
///   • pag-toggle sa favorite
///   • pag-navigate sa book detail page
class BookListItem extends ConsumerWidget {
  final Book book;

  /// Book object nga gihatag gikan sa list page
  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///  USER LIBRARY STATE
    /// Ginakuha ang full list sa books sa user
    final books = ref.watch(userLibraryProvider);

    /// FAVORITE STATUS
    /// Pangitaon ang current book pinaagi sa ID
    /// then kuhaon ang iyang isFavorite value
    final isFavorite = books.firstWhere((b) => b.id == book.id).isFavorite;

    return ListTile(
      /// Book icon sa left side
      leading: const Icon(Icons.book),

      /// Book title
      title: Text(book.title),

      /// Author ug genre info
      subtitle: Text('${book.author} • ${book.genre}'),

      /// Right-side actions (rating + favorite button)
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Display rating (kung naa)
          Text(book.rating?.toStringAsFixed(1) ?? '-'),

          /// Favorite toggle button
          IconButton(
            icon: Icon(
              /// Conditional icon depende kung favorite or dili
              isFavorite ? Icons.favorite : Icons.favorite_border,

              /// Red color kung favorite
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              /// Toggle favorite status sa book
              /// pinaagi sa provider notifier
              ref.read(userLibraryProvider.notifier).toggleFavorite(book.id);
            },
          ),
        ],
      ),

      /// ON TAP → OPEN BOOK DETAILS
      ///
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            /// I-pass ang book object sa detail page
            builder: (_) => BookDetailPage(book: book),
          ),
        );
      },
    );
  }
}
