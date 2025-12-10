// FILE: lib/models/book.dart
import 'package:flutter/foundation.dart';

enum BookStatus { toRead, reading, finished }

@immutable
class Book {
  final String id;
  final String title;
  final String author;
  final int pages;
  final String genre;
  final String? coverUrl;
  final DateTime dateAdded;
  final double? rating;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pages,
    required this.genre,
    this.coverUrl,
    required this.dateAdded,
    this.rating,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? pages,
    String? genre,
    String? coverUrl,
    DateTime? dateAdded,
    double? rating,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      pages: pages ?? this.pages,
      genre: genre ?? this.genre,
      coverUrl: coverUrl ?? this.coverUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      rating: rating ?? this.rating,
    );
  }
}
