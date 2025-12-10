import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/providers/book_providers.dart';

void main() {
  test('UserLibraryProvider adds book to shelf', () {
    final container = ProviderContainer();
    final notifier = container.read(userLibraryProvider.notifier);

    notifier.addToShelf('book1', ShelfType.reading);
    final lib = container.read(userLibraryProvider);

    expect(lib.shelves['book1'], ShelfType.reading);
  });

  test('BookProgressProvider updates progress', () {
    final container = ProviderContainer();
    final notifier = container.read(bookProgressProvider.notifier);

    notifier.updateProgress('book1', 50, 100);
    final progress = container.read(bookProgressProvider)['book1'];

    expect(progress?.currentPage, 50);
    expect(progress?.percentage, 0.5);
  });
}
