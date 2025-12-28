import 'package:flutter/foundation.dart';

/// BookProgress
/// - Model class nga nag-represent sa reading progress sa usa ka book
/// - Immutable aron safe gamiton sa Riverpod state management
@immutable
class BookProgress {
  /// Current page nga naabot sa reader
  /// Example: page 120
  final int currentPage;

  /// Percentage sa progress (0.0 – 1.0)
  /// Example: 0.5 = 50% completed
  final double percentage;

  /// Total number of pages sa book
  /// Gigamit para sa progress calculation
  final int totalPages;

  /// Constructor
  /// - Required tanan fields kay complete representation sa progress
  const BookProgress({
    required this.currentPage,
    required this.percentage,
    required this.totalPages,
  });
}
