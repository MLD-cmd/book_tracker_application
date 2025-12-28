import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main feature pages
import 'features/book_list/book_list_page.dart';
import 'features/book_list/book_detail/book_detail_page.dart';
import 'features/book_list/reading_session/reading_session_page.dart';
import 'features/book_list/analytics/analytics_page.dart';

// Book model
import 'models/book.dart';

/// APP ENTRY POINT

void main() {
  // ProviderScope is required by Riverpod
  runApp(const ProviderScope(child: BookTrackerApp()));
}

/// ROOT APPLICATION WIDGET

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove debug banner
      title: 'Book Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeNavigator(), // main navigation controller
    );
  }
}

/// HOME NAVIGATOR (BOTTOM NAV BAR)

/// Controls which main page is shown
/// using BottomNavigationBar
class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  // Currently selected tab index
  int _selectedIndex = 0;

  // Pages displayed for each tab
  final List<Widget> _pages = const [
    BookListPage(), // Library tab
    AnalyticsPage(), // Analytics tab
  ];

  /// Update selected tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display selected page
      body: _pages[_selectedIndex],

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// NAVIGATION HELPERS (OPTIONAL)

/// These functions simplify navigation
/// across the app and avoid code duplication

/// Navigate to book detail page
void navigateToBookDetail(BuildContext context, Book book) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
  );
}

/// Navigate to reading session page
void navigateToReadingSession(BuildContext context, String bookId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ReadingSessionPage(bookId: bookId)),
  );
}

/// Navigate to analytics page
void navigateToAnalytics(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AnalyticsPage()),
  );
}
