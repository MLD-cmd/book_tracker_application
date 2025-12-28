import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/book_providers.dart';
import 'book_list_item.dart';

/// BookListPage
/// - Main library screen sa app
/// - Responsible sa:
///   • pag-display sa list sa books
///   • filtering by shelf
///   • searching by title or author
class BookListPage extends ConsumerWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ===== FILTERED & SORTED BOOKS =====
    /// Kini nga provider nag-combine sa:
    ///   • all books
    ///   • shelf filter
    ///   • search query
    ///   • sorting logic
    /// Result: final list nga ipakita sa UI
    final books = ref.watch(filteredSortedBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tracker'),

        /// FILTER MENU (SHELF)
        actions: [
          PopupMenuButton<ShelfType?>(
            onSelected: (value) {
              /// Update sa shelf filter state
              /// - null → show all books
              /// - value → filter by selected shelf
              ref
                  .read(filtersProvider.notifier)
                  .update((f) => f.copyWith(shelf: value));
            },

            /// Filter options
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('All')),
              PopupMenuItem(
                value: ShelfType.wantToRead,
                child: Text('Want to Read'),
              ),
              PopupMenuItem(
                value: ShelfType.currentlyReading,
                child: Text('Reading'),
              ),
              PopupMenuItem(value: ShelfType.finished, child: Text('Finished')),
            ],

            /// Filter icon
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),

      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search title or author',
                prefixIcon: Icon(Icons.search),
              ),

              /// Update search query state every time user types
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),

          /// BOOK LIST VIEW
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                /// Each book rendered using BookListItem widget
                return BookListItem(book: books[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
