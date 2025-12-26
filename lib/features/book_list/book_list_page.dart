import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/book_providers.dart';
import 'book_list_item.dart';

class BookListPage extends ConsumerWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(filteredSortedBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tracker'),
        actions: [
          PopupMenuButton<ShelfType?>(
            onSelected: (value) {
              ref.read(filtersProvider.notifier).update(
                    (f) => f.copyWith(shelf: value),
                  );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('All')),
              PopupMenuItem(
                  value: ShelfType.wantToRead,
                  child: Text('Want to Read')),
              PopupMenuItem(
                  value: ShelfType.currentlyReading,
                  child: Text('Reading')),
              PopupMenuItem(
                  value: ShelfType.finished,
                  child: Text('Finished')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search title or author',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookListItem(book: books[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
