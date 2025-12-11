import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/book_providers.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(readingStatsProvider);
    final goal = ref.watch(readingGoalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Books Read This Month: ${stats['booksReadThisMonth']}'),
            Text('Total Pages Read: ${stats['totalPagesRead']}'),
            Text(
              'Average Rating: ${stats['averageRating']?.toStringAsFixed(1)}',
            ),
            const SizedBox(height: 20),
            Text('Monthly Goal: ${goal.monthlyGoal} pages'),
            Text('Progress: ${goal.progress} pages'),
          ],
        ),
      ),
    );
  }
}
