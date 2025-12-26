import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_tracker/providers/book_providers.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/reading_session.dart';

void main() {
  group('User Library Provider', () {
    test('toggle favorite works', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final books = container.read(userLibraryProvider);
      final bookId = books.first.id;

      container
          .read(userLibraryProvider.notifier)
          .toggleFavorite(bookId);

      final updatedBook = container
          .read(userLibraryProvider)
          .firstWhere((b) => b.id == bookId);

      expect(updatedBook.isFavorite, true);
    });

    test('shelf update works', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final bookId = container.read(userLibraryProvider).first.id;

      container
          .read(userLibraryProvider.notifier)
          .setShelf(bookId, ShelfType.finished);

      final updatedBook = container
          .read(userLibraryProvider)
          .firstWhere((b) => b.id == bookId);

      expect(updatedBook.shelf, ShelfType.finished);
    });
  });

  group('Reading Progress Provider', () {
    test('progress updates correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final book = container.read(userLibraryProvider).first;

      container
          .read(bookProgressProvider.notifier)
          .updateProgress(book.id, 100, book.pages);

      final progress =
          container.read(bookProgressProvider)[book.id];

      expect(progress?.currentPage, 100);
      expect(progress?.percentage, greaterThan(0));
    });
  });

  group('Reading Session Provider', () {
    test('session start and end', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final book = container.read(userLibraryProvider).first;

      container
          .read(readingSessionProvider.notifier)
          .startSession(book.id, 10);

      expect(container.read(readingSessionProvider), isNotNull);

      container
          .read(readingSessionProvider.notifier)
          .endSession(endPage: 20);

      expect(container.read(readingSessionProvider), isNull);

      final history =
          container.read(readingSessionHistoryProvider);

      expect(history.isNotEmpty, true);
    });
  });

  group('Analytics Provider', () {
    test('reading statistics calculate', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stats = container.read(readingStatisticsProvider);

      expect(stats.totalPagesRead, greaterThanOrEqualTo(0));
      expect(stats.booksReadThisYear, greaterThanOrEqualTo(0));
    });

    test('reading goal updates', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(readingGoalProvider.notifier)
          .addProgress(50);

      final goal = container.read(readingGoalProvider);

      expect(goal.progress, 50);
    });
  });
}
