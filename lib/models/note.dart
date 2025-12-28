import 'package:flutter/foundation.dart';

/// Note
/// - Model class para sa notes nga gi-himo sa user
/// - Ang matag note kay naka-link sa usa ka specific book
/// - Immutable aron safe gamiton sa Riverpod state management
@immutable
class Note {
  /// Unique identifier sa note
  /// Gigamit para:
  /// - pag-manage (add/delete)
  /// - pag-track sa individual notes
  final String id;

  /// ID sa book nga gi-refer sa note
  /// Mao ni ang connection sa Note ug Book
  final String bookId;

  /// Main content sa note
  /// Mao ni ang text nga gisulat sa user
  final String content;

  /// Page number sa libro kung asa nahimo ang note
  /// Gigamit para reference sa reading context
  final int page;

  /// Date ug time kung kanus-a gihimo ang note
  /// Gigamit para sorting ug history
  final DateTime created;

  /// Constructor
  /// - All fields kay required
  /// - Sigurado nga kompleto ang note data
  const Note({
    required this.id,
    required this.bookId,
    required this.content,
    required this.page,
    required this.created,
  });
}
