// FILE: lib/data/mock_books.dart
import 'package:uuid/uuid.dart';
import '../models/book.dart';

final _uuid = Uuid();

List<Book> generateMockBooks([int n = 120]) {
  final genres = [
    'Fantasy',
    'Sci-Fi',
    'Non-Fiction',
    'Romance',
    'Thriller',
    'Mystery',
  ];
  return List.generate(n, (i) {
    final g = genres[i % genres.length];
    return Book(
      id: _uuid.v4(),
      title: 'Book Title ${i + 1}',
      author: 'Author ${i % 40 + 1}',
      pages: 120 + (i % 400),
      genre: g,
      coverUrl: null,
      dateAdded: DateTime.now().subtract(Duration(days: i)),
      rating: ((i % 5) + 1).toDouble(),
    );
  });
}

final mockBooks = generateMockBooks();
