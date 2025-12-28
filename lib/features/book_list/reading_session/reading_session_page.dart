import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/book_providers.dart';

/// ReadingSessionPage
/// - Page nga responsible sa actual reading session
/// - Diri ginatrack:
///   • unsang libro ang gibasa
///   • unsa ka dugay ang session
///   • hangtod asa nga page ang nabasa
class ReadingSessionPage extends ConsumerStatefulWidget {
  final String bookId;

  /// bookId gihatag gikan sa BookDetailPage
  /// aron mahibal-an unsang libro ang session
  const ReadingSessionPage({super.key, required this.bookId});

  @override
  ConsumerState<ReadingSessionPage> createState() => _ReadingSessionPageState();
}

class _ReadingSessionPageState extends ConsumerState<ReadingSessionPage> {
  /// Controller para sa input sa current page
  final pageController = TextEditingController();

  /// Important: i-dispose ang controller
  /// aron malikayan ang memory leaks
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// CURRENT READING SESSION STATE
    /// - null kung walay active session
    /// - adunay value kung nagbasa pa
    final session = ref.watch(readingSessionProvider);

    /// SESSION TIMER
    /// - AsyncValue<Duration>
    /// - naga-update every second
    final timer = ref.watch(sessionTimerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// IF WALAY ACTIVE SESSION
            session == null
                ? ElevatedButton(
                    onPressed: () {
                      /// Start new reading session
                      /// Arguments:
                      /// - bookId: unsang libro
                      /// - startPage: starting page (0 by default)
                      ref
                          .read(readingSessionProvider.notifier)
                          .startSession(widget.bookId, 0);
                    },
                    child: const Text('Start Session'),
                  )
                /// IF NAA NA ACTIVE SESSION
                : Column(
                    children: [
                      /// TIMER DISPLAY

                      /// AsyncValue handling:
                      /// - data → show duration
                      /// - loading → spinner
                      /// - error → error message
                      timer.when(
                        data: (duration) => Text(
                          'Time: '
                          '${duration.inMinutes}:'
                          '${duration.inSeconds % 60}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      ),

                      const SizedBox(height: 16),

                      /// INPUT CURRENT PAGE

                      /// User input kung hangtod asa siya ni-abot
                      TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Current Page',
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// END SESSION BUTTON
                      ElevatedButton(
                        onPressed: () {
                          /// Convert input to int
                          /// Kung invalid → 0
                          final endPage =
                              int.tryParse(pageController.text) ?? 0;

                          /// End the reading session
                          /// - I-stop ang timer
                          /// - I-save ang duration
                          /// - I-update ang book progress
                          ref
                              .read(readingSessionProvider.notifier)
                              .endSession(endPage: endPage);

                          /// Clear input field
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
