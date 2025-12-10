import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/book_providers.dart';

class ReadingSessionPage extends ConsumerWidget {
  final String bookId;
  const ReadingSessionPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(readingSessionProvider);
    final timer = ref.watch(sessionTimerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Session')),
      body: Column(
        children: [
          session == null
              ? ElevatedButton(
                  onPressed: () {
                    ref.read(readingSessionProvider.notifier).startSession(bookId, 0);
                  },
                  child: const Text('Start Session'),
                )
              : Column(
                  children: [
                    timer.when(
                      data: (duration) => Text('Time: ${duration.inMinutes}:${duration.inSeconds % 60}'),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(readingSessionProvider.notifier).endSession(endPage: 10);
                      },
                      child: const Text('End Session'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}