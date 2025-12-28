import 'package:flutter/foundation.dart';
import '../providers/book_providers.dart';

/// Book
/// - Main model class sa application
/// - Nag-represent sa usa ka libro sa user library
/// - Immutable aron safe gamiton sa Riverpod state management
@immutable
class Book {
  /// Unique identifier sa book
  /// Gigamit para:
  /// - pag-update
  /// - pag-delete
  /// - pag-track sa progress ug notes
  final String id;

  /// Title sa libro
  final String title;

  /// Author sa libro
  final String author;

  /// Total number of pages sa libro
  /// Gigamit sa progress ug analytics
  final int pages;

  /// Genre sa libro (Fantasy, Sci-Fi, etc.)
  /// Gigamit sa analytics ug filtering
  final String genre;

  /// Optional URL sa book cover image
  /// Null kung walay image
  final String? coverUrl;

  /// Date kung kanus-a gi-add ang book sa library
  /// Gigamit para sorting ug analytics
  final DateTime dateAdded;

  /// Optional rating sa book (1–5)
  /// Null kung wala pa na-rate
  final double? rating;

  /// Shelf status sa book
  /// Values:
  /// - wantToRead
  /// - currentlyReading
  /// - finished
  final ShelfType shelf;

  /// Favorite flag
  /// True kung gi-mark as favorite ang book
  final bool isFavorite;

  /// List of tags sa book
  /// Example: ["long", "classic", "school"]
  final List<String> tags;

  /// Constructor
  /// - Required ang main fields
  /// - Naay default values para shelf, favorite, ug tags
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.pages,
    required this.genre,
    this.coverUrl,
    required this.dateAdded,
    this.rating,
    this.shelf = ShelfType.wantToRead,
    this.isFavorite = false,
    this.tags = const [],
  });

  /// copyWith
  /// - Gigamit para mag-update sa book state
  /// - Imbes i-mutate ang object, naghimo og bag-ong instance
  /// - Standard pattern sa immutable models
  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? pages,
    String? genre,
    String? coverUrl,
    DateTime? dateAdded,
    double? rating,
    ShelfType? shelf,
    bool? isFavorite,
    List<String>? tags,
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
      shelf: shelf ?? this.shelf,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }
}
