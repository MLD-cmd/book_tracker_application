import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../models/book_progress.dart';
import '../models/note.dart';
import '../models/reading_session.dart';
import '../data/mock_books.dart';
import '../services/book_repository.dart';


// =======================================================
// ENUMS & FILTER MODELS
// =======================================================

enum ShelfType {
  wantToRead,
  currentlyReading,
  finished,
}

enum SortOption {
  dateAdded,
  title,
  author,
  rating,
}

class BookFilters {
  final ShelfType? shelf;
  final String? genre;
  final double? minRating;

  const BookFilters({
    this.shelf,
    this.genre,
    this.minRating,
  });

  BookFilters copyWith({
    ShelfType? shelf,
    String? genre,
    double? minRating,
  }) {
    return BookFilters(
      shelf: shelf ?? this.shelf,
      genre: genre ?? this.genre,
      minRating: minRating ?? this.minRating,
    );
  }
}


// =======================================================
// BOOK DATA
// =======================================================

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepository(mockBooks),
);

final booksLibraryProvider = Provider<List<Book>>(
  (ref) => ref.watch(bookRepositoryProvider).getBooks(),
);


// =======================================================
// USER LIBRARY (Shelf, Rating, Favorites)
// =======================================================

class UserLibraryNotifier extends StateNotifier<List<Book>> {
  UserLibraryNotifier(List<Book> initialBooks) : super(initialBooks);

  void setShelf(String bookId, ShelfType shelf) {
    state = [
      for (final book in state)
        if (book.id == bookId)
          book.copyWith(shelf: shelf)
        else
          book,
    ];
  }

  void setRating(String bookId, double rating) {
    state = [
      for (final book in state)
        if (book.id == bookId)
          book.copyWith(rating: rating)
        else
          book,
    ];
  }

  void toggleFavorite(String bookId) {
    state = [
      for (final book in state)
        if (book.id == bookId)
          book.copyWith(isFavorite: !book.isFavorite)
        else
          book,
    ];
  }

  void addTag(String bookId, String tag) {
  state = [
    for (final book in state)
      if (book.id == bookId)
        book.copyWith(tags: [...book.tags, tag])
      else
        book,
  ];
}

void removeTag(String bookId, String tag) {
  state = [
    for (final book in state)
      if (book.id == bookId)
        book.copyWith(tags: book.tags.where((t) => t != tag).toList())
      else
        book,
  ];
}

}

final userLibraryProvider =
    StateNotifierProvider<UserLibraryNotifier, List<Book>>((ref) {
  final books = ref.watch(booksLibraryProvider);
  return UserLibraryNotifier(books);
});


// =======================================================
// SHELF PROVIDER (family)
// =======================================================

final shelfProvider = Provider.family<List<Book>, ShelfType>((ref, shelf) {
  final books = ref.watch(userLibraryProvider);
  return books.where((b) => b.shelf == shelf).toList();
});


// =======================================================
// BOOK PROGRESS
// =======================================================

class BookProgressNotifier extends StateNotifier<Map<String, BookProgress>> {
  BookProgressNotifier() : super({});

  void updateProgress(String bookId, int page, int totalPages) {
    final percentage =
        totalPages == 0 ? 0.0 : page / totalPages;

    state = {
      ...state,
      bookId: BookProgress(
        currentPage: page,
        percentage: percentage,
        totalPages: totalPages,
      ),
    };
  }

  void resetProgress(String bookId) {
    final copy = {...state}..remove(bookId);
    state = copy;
  }
}

final bookProgressProvider =
    StateNotifierProvider<BookProgressNotifier, Map<String, BookProgress>>(
  (ref) => BookProgressNotifier(),
);


// =======================================================
// READING SESSION
// =======================================================

class ReadingSessionNotifier extends StateNotifier<ReadingSession?> {
  ReadingSessionNotifier(this.ref) : super(null);
  final Ref ref;

  void startSession(String bookId, int startingPage) {
    state = ReadingSession(
      bookId: bookId,
      startTime: DateTime.now(),
      startingPage: startingPage,
    );
  }

  void endSession({required int endPage}) {
  final session = state;
  if (session == null) return;

  final books = ref.read(userLibraryProvider);
  final book = books.firstWhere((b) => b.id == session.bookId);

  final pagesRead = endPage - session.startingPage;

  // Finalize session with end data
  final finishedSession = session.copyWith(
    endTime: DateTime.now(),
    endingPage: endPage,
  ); 

  // Update book progress
  ref
      .read(bookProgressProvider.notifier)
      .updateProgress(session.bookId, endPage, book.pages);

  // Update reading goal progress
  ref
      .read(readingGoalProvider.notifier)
      .addProgress(pagesRead);

  // Save session history
  ref
      .read(readingSessionHistoryProvider.notifier)
      .addSession(finishedSession);

  state = null;
}

}

final readingSessionProvider =
    StateNotifierProvider<ReadingSessionNotifier, ReadingSession?>(
  (ref) => ReadingSessionNotifier(ref),
);


// =======================================================
// SESSION TIMER
// =======================================================

final sessionTimerProvider =
    StreamProvider.autoDispose<Duration>((ref) async* {
  final session = ref.watch(readingSessionProvider);
  if (session == null) return;

  while (ref.watch(readingSessionProvider) != null) {
    await Future.delayed(const Duration(seconds: 1));
    final current = ref.watch(readingSessionProvider);
    if (current == null) break;
    yield DateTime.now().difference(current.startTime);
  }
});


// =======================================================
// NOTES
// =======================================================

class NotesNotifier extends StateNotifier<Map<String, List<Note>>> {
  NotesNotifier() : super({});

  void addNote(Note note) {
    final notes = List<Note>.from(state[note.bookId] ?? [])
      ..add(note);

    state = {...state, note.bookId: notes};
  }

  void removeNote(String bookId, String noteId) {
    final notes = List<Note>.from(state[bookId] ?? [])
      ..removeWhere((n) => n.id == noteId);

    state = {...state, bookId: notes};
  }
}

final notesProvider =
    StateNotifierProvider<NotesNotifier, Map<String, List<Note>>>(
  (ref) => NotesNotifier(),
);


// =======================================================
// SEARCH, FILTER, SORT
// =======================================================

final searchQueryProvider = StateProvider<String>((ref) => '');

final filtersProvider =
    StateProvider<BookFilters>((ref) => const BookFilters());

final sortOptionProvider =
    StateProvider<SortOption>((ref) => SortOption.dateAdded);

final filteredBooksProvider = Provider<List<Book>>((ref) {
  final books = ref.watch(userLibraryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filters = ref.watch(filtersProvider);

  return books.where((book) {
    final matchesSearch =
        book.title.toLowerCase().contains(query) ||
        book.author.toLowerCase().contains(query);

    final matchesShelf =
        filters.shelf == null || book.shelf == filters.shelf;

    final matchesGenre =
        filters.genre == null || book.genre == filters.genre;

    final matchesRating =
        filters.minRating == null ||
        (book.rating ?? 0) >= filters.minRating!;

    return matchesSearch &&
        matchesShelf &&
        matchesGenre &&
        matchesRating;
  }).toList();
});

final filteredSortedBooksProvider = Provider<List<Book>>((ref) {
  final books = [...ref.watch(filteredBooksProvider)];
  final sort = ref.watch(sortOptionProvider);

  switch (sort) {
    case SortOption.dateAdded:
      books.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      break;
    case SortOption.title:
      books.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SortOption.author:
      books.sort((a, b) => a.author.compareTo(b.author));
      break;
    case SortOption.rating:
      books.sort(
        (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0),
      );
      break;
  }
  return books;
});


// =======================================================
// READING SESSION HISTORY & STREAK
// =======================================================

class ReadingSessionHistoryNotifier
    extends StateNotifier<List<ReadingSession>> {
  ReadingSessionHistoryNotifier() : super([]);

  void addSession(ReadingSession session) {
    state = [...state, session];
  }
}

final readingSessionHistoryProvider =
    StateNotifierProvider<ReadingSessionHistoryNotifier, List<ReadingSession>>(
  (ref) => ReadingSessionHistoryNotifier(),
);

final streakProvider = Provider<int>((ref) {
  final sessions = ref.watch(readingSessionHistoryProvider);
  if (sessions.isEmpty) return 0;

  final sorted = [...sessions]
    ..sort((a, b) => b.startTime.compareTo(a.startTime));

  int streak = 1;
  for (int i = 1; i < sorted.length; i++) {
    if (sorted[i - 1]
            .startTime
            .difference(sorted[i].startTime)
            .inDays <=
        1) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
});


// =======================================================
// READING STATISTICS
// =======================================================

class ReadingStatistics {
  final int booksReadThisMonth;
  final int booksReadThisYear;
  final int totalPagesRead;
  final double averageRating;
  final Map<String, int> genreDistribution;

  ReadingStatistics({
    required this.booksReadThisMonth,
    required this.booksReadThisYear,
    required this.totalPagesRead,
    required this.averageRating,
    required this.genreDistribution,
  });
}

final readingStatisticsProvider = Provider<ReadingStatistics>((ref) {
  final progress = ref.watch(bookProgressProvider);
  final books = ref.watch(userLibraryProvider);
  final now = DateTime.now();

  final totalPagesRead =
      progress.values.fold(0, (p, e) => p + e.currentPage);

  final ratings =
      books.map((b) => b.rating).whereType<double>().toList();

  final avgRating = ratings.isEmpty
      ? 0.0
      : ratings.reduce((a, b) => a + b) / ratings.length;

  final genreDistribution = <String, int>{};
  for (final b in books) {
    genreDistribution[b.genre] =
        (genreDistribution[b.genre] ?? 0) + 1;
  }

  return ReadingStatistics(
    booksReadThisMonth:
        books.where((b) => b.dateAdded.month == now.month).length,
    booksReadThisYear:
        books.where((b) => b.dateAdded.year == now.year).length,
    totalPagesRead: totalPagesRead,
    averageRating: avgRating,
    genreDistribution: genreDistribution,
  );
});

// =======================================================
// READING GOAL
// =======================================================

class ReadingGoal {
  final int monthlyGoal;
  final int progress;

  const ReadingGoal({
    required this.monthlyGoal,
    required this.progress,
  });

  ReadingGoal copyWith({
    int? monthlyGoal,
    int? progress,
  }) {
    return ReadingGoal(
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
      progress: progress ?? this.progress,
    );
  }
}

class ReadingGoalNotifier extends StateNotifier<ReadingGoal> {
  ReadingGoalNotifier() : super(const ReadingGoal(monthlyGoal: 1000, progress: 0));

  void addProgress(int pages) {
    state = state.copyWith(progress: state.progress + pages);
  }

  void resetProgress() {
    state = state.copyWith(progress: 0);
  }

  void updateGoal(int pages) {
    state = state.copyWith(monthlyGoal: pages);
  }
}

final readingGoalProvider =
    StateNotifierProvider<ReadingGoalNotifier, ReadingGoal>(
  (ref) => ReadingGoalNotifier(),
);
