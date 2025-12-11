import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/book_providers.dart';

class ReadingSessionPage extends ConsumerStatefulWidget {
  final String bookId;
  const ReadingSessionPage({super.key, required this.bookId});

  @override
  ConsumerState<ReadingSessionPage> createState() => _ReadingSessionPageState();
}

class _ReadingSessionPageState extends ConsumerState<ReadingSessionPage> {
  final pageController = TextEditingController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(readingSessionProvider);
    final timer = ref.watch(sessionTimerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            session == null
                ? ElevatedButton(
                    onPressed: () {
                      ref
                          .read(readingSessionProvider.notifier)
                          .startSession(widget.bookId, 0);
                    },
                    child: const Text('Start Session'),
                  )
                : Column(
                    children: [
                      timer.when(
                        data: (duration) => Text(
                          'Time: ${duration.inMinutes}:${duration.inSeconds % 60}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Current Page',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final endPage =
                              int.tryParse(pageController.text) ?? 0;

                          // End session and update progress
                          ref
                              .read(readingSessionProvider.notifier)
                              .endSession(endPage: endPage);

                          pageController.clear();
                        },
                        child: const Text('End Session'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
