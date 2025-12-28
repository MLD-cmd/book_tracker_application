import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note model
import '../models/note.dart';

// Provider nga nag-handle sa notes state
import '../providers/book_providers.dart';

// Package para automatic unique ID
import 'package:uuid/uuid.dart';

// UUID generator (gigamit para unique note ID)
final _uuid = Uuid();

/// Widget para **pag-add og note sa usa ka book**
/// Stateful kay naay text input ug page number
class NoteEditor extends ConsumerStatefulWidget {
  // ID sa book nga gi-butan og note
  final String bookId;

  const NoteEditor({super.key, required this.bookId});

  @override
  ConsumerState<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  // Controller para sa note text input
  final _controller = TextEditingController();

  // Page number kung asa ang note (default = 1)
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // NOTE TEXT INPUT
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Note'),
        ),

        // PAGE NUMBER INPUT
        TextField(
          decoration: const InputDecoration(labelText: 'Page'),
          keyboardType: TextInputType.number,

          // Convert input to int, fallback to 1 if invalid
          onChanged: (v) => _page = int.tryParse(v) ?? 1,
        ),

        // ADD NOTE BUTTON
        ElevatedButton(
          onPressed: () {
            // Create new Note object
            final note = Note(
              id: _uuid.v4(), // unique ID
              bookId: widget.bookId, // associated book
              content: _controller.text, // note content
              page: _page, // page number
              created: DateTime.now(), // timestamp
            );

            // Add note to global notes provider
            ref.read(notesProvider.notifier).addNote(note);

            // Clear text field after saving
            _controller.clear();
          },
          child: const Text('Add Note'),
        ),
      ],
    );
  }
}
