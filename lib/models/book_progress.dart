import 'package:flutter/foundation.dart';

@immutable
class BookProgress {
  final int currentPage;
  final double percentage;
  final int totalPages;

  const BookProgress({
    required this.currentPage,
    required this.percentage,
    required this.totalPages,
  });
}
