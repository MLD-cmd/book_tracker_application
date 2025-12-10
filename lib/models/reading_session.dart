// FILE: lib/models/reading_session.dart
import 'package:flutter/foundation.dart';

@immutable
class ReadingSession {
  final String bookId;
  final DateTime startTime;
  final int startingPage;

  const ReadingSession({
    required this.bookId,
    required this.startTime,
    required this.startingPage,
  });
}
