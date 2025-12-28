import 'package:uuid/uuid.dart';
import '../models/book.dart';

/// UUID generator
/// Gigamit para makahimo og unique ID sa matag book
/// Importante aron walay duplicate IDs sa app
final _uuid = Uuid();

/// Function nga nag-generate og mock book data
/// [n] = number of books nga buhaton (default = 120)
/// Gigamit ni para:
/// - initial data sa app
/// - testing
/// - demo purposes (walay backend/database)
List<Book> generateMockBooks([int n = 120]) {
  /// List of predefined genres
  /// Gi-rotate ni gamit modulo (%) para ma-assign evenly
  final genres = [
    'Fantasy',
    'Sci-Fi',
    'Non-Fiction',
    'Romance',
    'Thriller',
    'Mystery',
  ];

  /// List.generate creates a list of [n] Book objects
  return List.generate(n, (i) {
    /// Pilion ang genre based sa index
    /// Example: kung i = 0 → Fantasy, i = 1 → Sci-Fi, etc.
    final g = genres[i % genres.length];

    /// Book object creation
    return Book(
      id: _uuid.v4(), // unique ID per book
      title: 'Book Title ${i + 1}', // dynamic title
      author: 'Author ${i % 40 + 1}', // reuse authors (1–40)
      pages: 120 + (i % 400), // page count variation
      genre: g, // assigned genre
      coverUrl: null, // placeholder (walay image for now)
      dateAdded: DateTime.now().subtract(
        Duration(days: i),
      ), // simulate different dates
      rating: ((i % 5) + 1).toDouble(), // rating from 1.0 to 5.0
    );
  });
}

/// Global variable nga nag-store sa generated mock books
/// Kini ang gigamit sa repository/provider as initial data
final mockBooks = generateMockBooks();
