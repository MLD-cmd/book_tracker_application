import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/book.dart';
import '/providers/book_providers.dart';
import 'package:book_tracker/widgets/note_editor.dart';
import '../reading_session/reading_session_page.dart';

class BookDetailPage extends ConsumerWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      bookProgressProvider.select((map) => map[book.id]),
    );

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

            Consumer(
              builder: (context, ref, _) {
                final books = ref.watch(userLibraryProvider);
                final currentBook =
                    books.firstWhere((b) => b.id == book.id);

                return DropdownButtonFormField<ShelfType>(
                  value: currentBook.shelf,
                  decoration: const InputDecoration(
                    labelText: 'Shelf',
                    border: OutlineInputBorder(),
                  ),
                  items: ShelfType.values.map((shelf) {
                    return DropdownMenuItem(
                      value: shelf,
                      child: Text(
                        shelf.name.replaceAllMapped(
                          RegExp(r'([A-Z])'),
                          (m) => ' ${m[0]}',
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(userLibraryProvider.notifier)
                          .setShelf(book.id, value);
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // ===============================
            // TAGS SECTION 
            // ===============================
            Consumer(
              builder: (context, ref, _) {
                final books = ref.watch(userLibraryProvider);
                final currentBook =
                    books.firstWhere((b) => b.id == book.id);

                final controller = TextEditingController();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: currentBook.tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                ref
                                    .read(userLibraryProvider.notifier)
                                    .removeTag(book.id, tag);
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Add tag',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              ref
                                  .read(userLibraryProvider.notifier)
                                  .addTag(book.id, controller.text.trim());
                              controller.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            Text(
              'Progress: ${progress?.currentPage ?? 0}/${book.pages} (${((progress?.percentage ?? 0) * 100).toStringAsFixed(1)}%)',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReadingSessionPage(bookId: book.id),
                  ),
                );
              },
              child: const Text('Start Reading Session'),
            ),
            const Divider(),
            NoteEditor(bookId: book.id),
          ],
        ),
      ),
    );
  }
}
