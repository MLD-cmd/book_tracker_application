/// ReadingSession
/// - Model class para sa usa ka reading session
/// - Nag-represent kung kanus-a nagsugod ug nahuman ang pagbasa sa usa ka book
/// - Gigamit para:
///   • time tracking
///   • reading analytics
///   • reading history
class ReadingSession {
  /// ID sa book nga gi-basahan
  /// Mao ni ang link tali sa ReadingSession ug Book
  final String bookId;

  /// Oras ug petsa kung kanus-a nagsugod ang reading session
  /// Gamiton para:
  /// - pag-compute sa reading duration
  /// - streak calculation
  final DateTime startTime;

  /// Page number kung asa nagsugod ang reading session
  /// Importante para:
  /// - reading progress
  /// - pages read calculation
  final int startingPage;

  /// Oras ug petsa kung kanus-a nahuman ang reading session
  /// Nullable kay:
  /// - null pa ni kung ongoing ang session
  final DateTime? endTime;

  /// Last page nga naabot sa session
  /// Nullable kay:
  /// - wala pa ni kung ongoing ang session
  final int? endingPage;

  /// Constructor
  /// - endTime ug endingPage kay optional
  /// - para ma-support ang "ongoing" nga session
  const ReadingSession({
    required this.bookId,
    required this.startTime,
    required this.startingPage,
    this.endTime,
    this.endingPage,
  });

  /// copyWith
  /// - Gigamit kung i-update ang session (example: pag-end sa session)
  /// - Dili gi-mutate ang original object
  /// - Nag-create og new ReadingSession instance
  ///
  /// Typical usage:
  /// - I-set ang endTime ug endingPage inig tapos sa session
  ReadingSession copyWith({DateTime? endTime, int? endingPage}) {
    return ReadingSession(
      bookId: bookId, // pareho gihapon nga book
      startTime: startTime, // original start time
      startingPage: startingPage, // original starting page
      endTime: endTime ?? this.endTime,
      endingPage: endingPage ?? this.endingPage,
    );
  }
}
