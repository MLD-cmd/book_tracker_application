// FILE: lib/models/note.dart
import 'package:flutter/foundation.dart';

@immutable
class Note {
  final String id;
  final String bookId;
  final String content;
  final int page;
  final DateTime created;

  const Note({
    required this.id,
    required this.bookId,
    required this.content,
    required this.page,
    required this.created,
  });
}
