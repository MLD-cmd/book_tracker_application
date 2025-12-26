import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/book_providers.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(readingStatisticsProvider);
    final goal = ref.watch(readingGoalProvider);
    final streak = ref.watch(streakProvider);

    final goalProgress =
        goal.monthlyGoal == 0 ? 0.0 : goal.progress / goal.monthlyGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // SUMMARY
            // ===============================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Books Read This Month: ${stats.booksReadThisMonth}'),
                    Text('Books Read This Year: ${stats.booksReadThisYear}'),
                    Text('Total Pages Read: ${stats.totalPagesRead}'),
                    Text(
                      'Average Rating: ${stats.averageRating.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===============================
            // READING GOAL
            // ===============================
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
                    LinearProgressIndicator(value: goalProgress.clamp(0, 1)),
                    const SizedBox(height: 8),
                    Text('${goal.progress} / ${goal.monthlyGoal} pages'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===============================
            // STREAK
            // ===============================
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.orange),
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
            // GENRE DISTRIBUTION
            // ===============================
            const Text(
              'Genre Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...stats.genreDistribution.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.key)),
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
