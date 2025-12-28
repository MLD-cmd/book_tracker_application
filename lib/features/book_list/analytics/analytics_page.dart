import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/book_providers.dart';

/// AnalyticsPage
/// - UI page nga nag-display sa reading analytics
/// - DILI ni siya nag-compute sa data
/// - Ang data tanan GIKUHA gikan sa Riverpod providers
///   (readingStatisticsProvider, readingGoalProvider, streakProvider)
class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ref.watch(...) = mo-listen sa provider
    /// Kung naay change sa provider, automatic mo rebuild ang UI

    /// Statistics summary (pages, ratings, genre counts, etc.)
    final stats = ref.watch(readingStatisticsProvider);

    /// Reading goal data (monthly goal + progress)
    final goal = ref.watch(readingGoalProvider);

    /// Reading streak (consecutive reading days)
    final streak = ref.watch(streakProvider);

    /// Calculate goal progress as percentage
    /// Avoid division by zero kung walay goal
    final goalProgress = goal.monthlyGoal == 0
        ? 0.0
        : goal.progress / goal.monthlyGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Analytics')),

      /// Scrollable para di mo overflow kung daghan data
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // SUMMARY SECTION
            // ===============================
            /// Summary card
            /// Data ani kay gikan sa ReadingStatistics provider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Books added/read this month
                    Text('Books Read This Month: ${stats.booksReadThisMonth}'),

                    /// Books added/read this year
                    Text('Books Read This Year: ${stats.booksReadThisYear}'),

                    /// Total pages read
                    /// Gikan ni sa BookProgress provider
                    Text('Total Pages Read: ${stats.totalPagesRead}'),

                    /// Average rating
                    /// Gicompute base sa ratings sa books
                    Text(
                      'Average Rating: ${stats.averageRating.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===============================
            // READING GOAL SECTION
            // ===============================
            /// Monthly reading goal progress
            /// Ang pages mo-increase kada human og reading session
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Reading Goal',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    /// Progress bar
                    /// value = percentage (0.0 - 1.0)
                    LinearProgressIndicator(value: goalProgress.clamp(0, 1)),

                    const SizedBox(height: 8),

                    /// Textual representation sa progress
                    Text('${goal.progress} / ${goal.monthlyGoal} pages'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===============================
            // STREAK SECTION
            // ===============================
            /// Reading streak
            /// Gikwenta base sa reading session history
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reading Streak: $streak days',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===============================
            // GENRE DISTRIBUTION SECTION
            // ===============================
            /// Breakdown sa books per genre
            /// Gikan gihapon sa ReadingStatistics provider
            const Text(
              'Genre Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// Loop through genreDistribution map
            /// Example: {Fantasy: 20, Romance: 15}
            ...stats.genreDistribution.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    /// Genre name
                    Expanded(child: Text(entry.key)),

                    /// Count of books in that genre
                    Text(entry.value.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
