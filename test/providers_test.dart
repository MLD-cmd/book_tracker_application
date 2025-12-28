import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// App providers and models
import 'package:book_tracker/providers/book_providers.dart';

void main() {
  /// USER LIBRARY PROVIDER TESTS

  group('User Library Provider', () {
    /// Test if favorite toggle updates correctly
    test('toggle favorite works', () {
      // Create isolated provider container for testing
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Get initial books from user library
      final books = container.read(userLibraryProvider);
      final bookId = books.first.id;

      // Toggle favorite status
      container.read(userLibraryProvider.notifier).toggleFavorite(bookId);

      // Fetch updated book
      final updatedBook = container
          .read(userLibraryProvider)
          .firstWhere((b) => b.id == bookId);

      // Expect favorite to be true
      expect(updatedBook.isFavorite, true);
    });

    /// Test if shelf update works correctly
    test('shelf update works', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Get first book ID
      final bookId = container.read(userLibraryProvider).first.id;

      // Update shelf to "finished"
      container
          .read(userLibraryProvider.notifier)
          .setShelf(bookId, ShelfType.finished);

      // Fetch updated book
      final updatedBook = container
          .read(userLibraryProvider)
          .firstWhere((b) => b.id == bookId);

      // Expect shelf to be updated
      expect(updatedBook.shelf, ShelfType.finished);
    });
  });

  /// BOOK PROGRESS PROVIDER TESTS

  group('Reading Progress Provider', () {
    test('progress updates correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Get a book from library
      final book = container.read(userLibraryProvider).first;

      // Update reading progress
      container
          .read(bookProgressProvider.notifier)
          .updateProgress(book.id, 100, book.pages);

      // Fetch progress for the book
      final progress = container.read(bookProgressProvider)[book.id];

      // Validate progress values
      expect(progress?.currentPage, 100);
      expect(progress?.percentage, greaterThan(0));
    });
  });

  /// READING SESSION PROVIDER TESTS

  group('Reading Session Provider', () {
    test('session start and end', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Get a book
      final book = container.read(userLibraryProvider).first;

      // Start reading session
      container.read(readingSessionProvider.notifier).startSession(book.id, 10);

      // Ensure session is active
      expect(container.read(readingSessionProvider), isNotNull);

      // End reading session
      container.read(readingSessionProvider.notifier).endSession(endPage: 20);

      // Session should be cleared
      expect(container.read(readingSessionProvider), isNull);

      // Session history should be saved
      final history = container.read(readingSessionHistoryProvider);

      expect(history.isNotEmpty, true);
    });
  });

  /// ANALYTICS & GOAL PROVIDER TESTS

  group('Analytics Provider', () {
    /// Test reading statistics calculation
    test('reading statistics calculate', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stats = container.read(readingStatisticsProvider);

      // Basic sanity checks
      expect(stats.totalPagesRead, greaterThanOrEqualTo(0));
      expect(stats.booksReadThisYear, greaterThanOrEqualTo(0));
    });

    /// Test reading goal progress update
    test('reading goal updates', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Add progress to reading goal
      container.read(readingGoalProvider.notifier).addProgress(50);

      // Fetch updated goal
      final goal = container.read(readingGoalProvider);

      // Expect progress to be updated
      expect(goal.progress, 50);
    });
  });
}
