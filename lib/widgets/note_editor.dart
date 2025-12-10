import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/book_providers.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class NoteEditor extends ConsumerStatefulWidget {
  final String bookId;
  const NoteEditor({super.key, required this.bookId});

  @override
  ConsumerState<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  final _controller = TextEditingController();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Note'),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Page'),
          keyboardType: TextInputType.number,
          onChanged: (v) => _page = int.tryParse(v) ?? 1,
        ),
        ElevatedButton(
          onPressed: () {
            final note = Note(
              id: _uuid.v4(),
              bookId: widget.bookId,
              content: _controller.text,
              page: _page,
              created: DateTime.now(),
            );
            ref.read(notesProvider.notifier).addNote(note);
            _controller.clear();
          },
          child: const Text('Add Note'),
        )
      ],
    );
  }
}

