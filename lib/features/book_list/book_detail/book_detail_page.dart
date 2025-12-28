import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/book.dart';
import '/providers/book_providers.dart';
import 'package:book_tracker/widgets/note_editor.dart';
import '../reading_session/reading_session_page.dart';

/// BookDetailPage
/// - Page nga nagpakita sa TANAN detalye sa usa ka book
/// - DILI ni siya ga-store og data
/// - Ang data tanan GIKUHA ug GI-UPDATE pinaagi sa Riverpod providers
class BookDetailPage extends ConsumerWidget {
  final Book book;

  /// Ang book object diri gikan sa BookListPage
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ===== BOOK PROGRESS =====
    /// ref.watch(...) + select(...)
    /// - Gakuha ra sa progress sa specific book (by book.id)
    /// - Mas efficient kay di mo-rebuild kung laing book ang nausab
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
            // BASIC BOOK INFO
            /// Gikan ni sa Book model
            Text('Author: ${book.author}'),
            Text('Genre: ${book.genre}'),
            Text('Pages: ${book.pages}'),
            Text('Rating: ${book.rating ?? '-'}'),

            // SHELF (Want to Read / Reading / Finished)
            /// Consumer kay mag depend sa userLibraryProvider
            Consumer(
              builder: (context, ref, _) {
                /// Full list sa books nga naa sa user library
                final books = ref.watch(userLibraryProvider);

                /// Pangitaon ang exact book nga gi-open
                final currentBook = books.firstWhere((b) => b.id == book.id);

                return DropdownButtonFormField<ShelfType>(
                  value: currentBook.shelf,
                  decoration: const InputDecoration(
                    labelText: 'Shelf',
                    border: OutlineInputBorder(),
                  ),

                  /// Generate dropdown items gikan sa ShelfType enum
                  items: ShelfType.values.map((shelf) {
                    return DropdownMenuItem(
                      value: shelf,
                      child: Text(
                        /// Para mahimong readable ang enum name
                        shelf.name.replaceAllMapped(
                          RegExp(r'([A-Z])'),
                          (m) => ' ${m[0]}',
                        ),
                      ),
                    );
                  }).toList(),

                  /// Kung usbon ang shelf:
                  /// → tawagon ang UserLibraryNotifier
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

            // TAGS SECTION
            /// Tags kay part sa Book object
            /// Gina-manage gihapon sa UserLibraryNotifier
            Consumer(
              builder: (context, ref, _) {
                final books = ref.watch(userLibraryProvider);
                final currentBook = books.firstWhere((b) => b.id == book.id);

                final controller = TextEditingController();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Display existing tags
                    Wrap(
                      spacing: 8,
                      children: currentBook.tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              deleteIcon: const Icon(Icons.close),

                              /// Remove tag
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

                    /// Add new tag
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
                              /// Add tag via notifier
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

            // READING PROGRESS
            /// Progress data gikan sa BookProgressProvider
            /// Gina-update ni during reading sessions
            Text(
              'Progress: '
              '${progress?.currentPage ?? 0}/${book.pages} '
              '(${((progress?.percentage ?? 0) * 100).toStringAsFixed(1)}%)',
            ),

            // START READING SESSION
            ElevatedButton(
              onPressed: () {
                /// Navigate to reading session page
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

            // NOTES SECTION

            /// NoteEditor:
            /// - Mag-add og notes para ani nga specific book
            /// - Ang notes gi-store sa NotesNotifier
            NoteEditor(bookId: book.id),
          ],
        ),
      ),
    );
  }
}
