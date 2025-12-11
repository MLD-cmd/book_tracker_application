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
