// FILE: lib/services/book_repository.dart
import '../models/book.dart';

class BookRepository {
  final List<Book> _books;

  BookRepository([List<Book>? initial]) : _books = List.from(initial ?? []);

  List<Book> getBooks() => List.unmodifiable(_books);

  Book? getById(String id) =>
      _books.firstWhere((b) => b.id == id, orElse: () => null);

  void addBook(Book b) => _books.add(b);

  void updateBook(Book b) {
    final i = _books.indexWhere((x) => x.id == b.id);
    if (i != -1) _books[i] = b;
  }

  void removeBook(String id) => _books.removeWhere((b) => b.id == id);
}
