import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../models/book_progress.dart';
import '../models/note.dart';
import '../models/reading_session.dart';
import '../data/mock_books.dart';
import '../services/book_repository.dart';

// Providers
final booksLibraryProvider = Provider<List<Book>>((ref) => mockBooks);
final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepository(mockBooks),
);

// User Library & shelves
enum ShelfType { wantToRead, reading, finished }

class UserLibrary {
  final Map<String, ShelfType> shelves;
  final Set<String> favorites;

  UserLibrary({Map<String, ShelfType>? shelves, Set<String>? favorites})
    : shelves = Map.unmodifiable(shelves ?? {}),
      favorites = Set.unmodifiable(favorites ?? {});
}

class UserLibraryNotifier extends StateNotifier<UserLibrary> {
  UserLibraryNotifier() : super(UserLibrary());

  void addToShelf(String bookId, ShelfType s) {
    final m = {...state.shelves, bookId: s};
    state = UserLibrary(shelves: m, favorites: state.favorites);
  }

  void removeFromShelf(String bookId) {
    final m = {...state.shelves}..remove(bookId);
    state = UserLibrary(shelves: m, favorites: state.favorites);
  }

  void toggleFavorite(String bookId) {
    final f = {...state.favorites};
    if (f.contains(bookId))
      f.remove(bookId);
    else
      f.add(bookId);
    state = UserLibrary(shelves: state.shelves, favorites: f);
  }
}

final userLibraryProvider =
    StateNotifierProvider<UserLibraryNotifier, UserLibrary>(
      (ref) => UserLibraryNotifier(),
    );

// Shelf provider (family)
final shelfProvider = Provider.family<List<Book>, ShelfType>((ref, shelfType) {
  final lib = ref.watch(userLibraryProvider);
  final books = ref.watch(booksLibraryProvider);
  final ids = lib.shelves.entries
      .where((e) => e.value == shelfType)
      .map((e) => e.key)
      .toSet();
  return books.where((b) => ids.contains(b.id)).toList();
});

// Book Progress
class BookProgressNotifier extends StateNotifier<Map<String, BookProgress>> {
  BookProgressNotifier() : super({});

  void updateProgress(String bookId, int page, int totalPages) {
    final pct = totalPages <= 0 ? 0.0 : (page / totalPages);
    state = {
      ...state,
      bookId: BookProgress(
        currentPage: page,
        percentage: pct,
        totalPages: totalPages,
      ),
    };
  }

  void resetProgress(String bookId) {
    final m = {...state}..remove(bookId);
    state = m;
  }
}

final bookProgressProvider =
    StateNotifierProvider<BookProgressNotifier, Map<String, BookProgress>>(
      (ref) => BookProgressNotifier(),
    );

// Reading Session
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
    final s = state;
    if (s == null) return;
    final books = ref.read(booksLibraryProvider);
    final book = books.firstWhere((b) => b.id == s.bookId);
    ref
        .read(bookProgressProvider.notifier)
        .updateProgress(s.bookId, endPage, book.pages);

    // Add session to history
    ref
        .read(readingSessionHistoryProvider.notifier)
        .addSession(
          ReadingSession(
            bookId: s.bookId,
            startTime: s.startTime,
            startingPage: s.startingPage,
          ),
        );

    state = null;
  }
}

final readingSessionProvider =
    StateNotifierProvider<ReadingSessionNotifier, ReadingSession?>(
      (ref) => ReadingSessionNotifier(ref),
    );

// Session Timer
final sessionTimerProvider = StreamProvider.autoDispose<Duration>((ref) async* {
  final session = ref.watch(readingSessionProvider);
  if (session == null) return;
  while (ref.watch(readingSessionProvider) != null) {
    await Future.delayed(const Duration(seconds: 1));
    final s = ref.watch(readingSessionProvider);
    if (s == null) break;
    yield DateTime.now().difference(s.startTime);
  }
});

// Notes
class NotesNotifier extends StateNotifier<Map<String, List<Note>>> {
  NotesNotifier() : super({});

  void addNote(Note n) {
    final List<Note> list = List<Note>.from(state[n.bookId] ?? [])..add(n);
    state = {...state, n.bookId: list};
  }

  void removeNote(String bookId, String noteId) {
    final List<Note> list = List<Note>.from(state[bookId] ?? [])
      ..removeWhere((note) => note.id == noteId);
    state = {...state, bookId: list};
  }
}

final notesProvider =
    StateNotifierProvider<NotesNotifier, Map<String, List<Note>>>(
      (ref) => NotesNotifier(),
    );

// Search & Filters
final searchQueryProvider = StateProvider<String>((ref) => '');

class BookFilters {
  final ShelfType? shelf;
  final String? genre;
  final double? minRating;
  const BookFilters({this.shelf, this.genre, this.minRating});
}

final filtersProvider = StateProvider<BookFilters>(
  (ref) => const BookFilters(),
);

// Computed filtered books
final filteredBooksProvider = Provider<List<Book>>((ref) {
  final all = ref.watch(booksLibraryProvider);
  final q = ref.watch(searchQueryProvider);
  final f = ref.watch(filtersProvider);
  final userLib = ref.watch(userLibraryProvider);

  var result = all;

  if (q.isNotEmpty) {
    final lower = q.toLowerCase();
    result = result
        .where(
          (b) =>
              b.title.toLowerCase().contains(lower) ||
              b.author.toLowerCase().contains(lower),
        )
        .toList();
  }

  if (f.shelf != null) {
    final ids = userLib.shelves.entries
        .where((e) => e.value == f.shelf)
        .map((e) => e.key)
        .toSet();
    result = result.where((b) => ids.contains(b.id)).toList();
  }

  if (f.genre != null)
    result = result.where((b) => b.genre == f.genre).toList();

  if (f.minRating != null)
    result = result.where((b) => (b.rating ?? 0) >= f.minRating!).toList();

  return result;
});

// Reading Stats
final readingStatsProvider = Provider((ref) {
  final progress = ref.watch(bookProgressProvider);
  final books = ref.watch(booksLibraryProvider);
  final totalPagesRead = progress.values.fold<int>(
    0,
    (p, e) => p + e.currentPage,
  );
  final ratings = books.map((b) => b.rating ?? 0).where((r) => r > 0).toList();
  final avgRating = ratings.isEmpty
      ? 0.0
      : ratings.reduce((a, b) => a + b) / ratings.length;

  return {
    'booksReadThisMonth': 0,
    'totalPagesRead': totalPagesRead,
    'averageRating': avgRating,
  };
});

// Reading Goal
class ReadingGoal {
  final int monthlyGoal;
  final int progress;
  ReadingGoal(this.monthlyGoal, this.progress);
}

class ReadingGoalNotifier extends StateNotifier<ReadingGoal> {
  ReadingGoalNotifier() : super(ReadingGoal(1000, 0));
  void addProgress(int pages) =>
      state = ReadingGoal(state.monthlyGoal, state.progress + pages);
  void reset() => state = ReadingGoal(state.monthlyGoal, 0);
}

final readingGoalProvider =
    StateNotifierProvider<ReadingGoalNotifier, ReadingGoal>(
      (ref) => ReadingGoalNotifier(),
    );

// --- Improved Reading Session History & Streak ---
final readingSessionHistoryProvider =
    StateNotifierProvider<ReadingSessionHistoryNotifier, List<ReadingSession>>(
      (ref) => ReadingSessionHistoryNotifier(),
    );

class ReadingSessionHistoryNotifier
    extends StateNotifier<List<ReadingSession>> {
  ReadingSessionHistoryNotifier() : super([]);

  void addSession(ReadingSession session) {
    state = [...state, session];
  }
}

final streakProvider = Provider<int>((ref) {
  final sessions = ref.watch(readingSessionHistoryProvider);
  if (sessions.isEmpty) return 0;

  final sorted = [...sessions]
    ..sort((a, b) => b.startTime.compareTo(a.startTime));
  int streak = 1;

  for (int i = 1; i < sorted.length; i++) {
    if (sorted[i - 1].startTime.difference(sorted[i].startTime).inDays <= 1) {
      streak++;
    } else {
      break;
    }
  }

  return streak;
});

// --- Analytics Provider ---
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
  final books = ref.watch(booksLibraryProvider);

  final now = DateTime.now();
  final booksReadThisMonth = books
      .where(
        (b) => b.dateAdded.month == now.month && b.dateAdded.year == now.year,
      )
      .length;
  final booksReadThisYear = books
      .where((b) => b.dateAdded.year == now.year)
      .length;
  final totalPagesRead = progress.values.fold<int>(
    0,
    (p, e) => p + e.currentPage,
  );

  final ratings = books.map((b) => b.rating ?? 0).where((r) => r > 0).toList();
  final avgRating = ratings.isEmpty
      ? 0.0
      : ratings.reduce((a, b) => a + b) / ratings.length;

  final genreDistribution = <String, int>{};
  for (var b in books) {
    genreDistribution[b.genre] = (genreDistribution[b.genre] ?? 0) + 1;
  }

  return ReadingStatistics(
    booksReadThisMonth: booksReadThisMonth,
    booksReadThisYear: booksReadThisYear,
    totalPagesRead: totalPagesRead,
    averageRating: avgRating,
    genreDistribution: genreDistribution,
  );
});

// --- Sorting Provider ---
enum SortOption { dateAdded, title, author, rating }

final sortOptionProvider = StateProvider<SortOption>(
  (ref) => SortOption.dateAdded,
);

final filteredSortedBooksProvider = Provider<List<Book>>((ref) {
  var books = ref.watch(filteredBooksProvider);
  final sortOption = ref.watch(sortOptionProvider);

  switch (sortOption) {
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
      books.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
      break;
  }

  return books;
});
