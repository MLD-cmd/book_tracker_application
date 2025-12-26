class ReadingSession {
  final String bookId;
  final DateTime startTime;
  final int startingPage;

  final DateTime? endTime;
  final int? endingPage;

  const ReadingSession({
    required this.bookId,
    required this.startTime,
    required this.startingPage,
    this.endTime,
    this.endingPage,
  });

  ReadingSession copyWith({
    DateTime? endTime,
    int? endingPage,
  }) {
    return ReadingSession(
      bookId: bookId,
      startTime: startTime,
      startingPage: startingPage,
      endTime: endTime ?? this.endTime,
      endingPage: endingPage ?? this.endingPage,
    );
  }
}
