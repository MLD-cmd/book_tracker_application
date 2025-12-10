// FILE: lib/services/book_repository.dart
import '../models/book.dart';

class BookRepository {
  final List<Book> _books;

  BookRepository([List<Book>? initial]) : _books = List.from(initial ?? []);

  /// Returns an unmodifiable list of all books
  List<Book> getBooks() => List.unmodifiable(_books);

  /// Returns a book by ID or null if not found
  Book? getById(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Adds a new book to the repository
  void addBook(Book b) => _books.add(b);

  /// Updates an existing book
  void updateBook(Book b) {
    final i = _books.indexWhere((x) => x.id == b.id);
    if (i != -1) _books[i] = b;
  }

  /// Removes a book by ID
  void removeBook(String id) => _books.removeWhere((b) => b.id == id);
}
