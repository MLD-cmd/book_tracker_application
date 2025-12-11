import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/book_list/book_list_page.dart';
import 'features/book_list/book_detail/book_detail_page.dart';
import 'features/book_list/reading_session/reading_session_page.dart';
import 'features/book_list/analytics/analytics_page.dart';
import 'models/book.dart';

void main() {
  runApp(const ProviderScope(child: BookTrackerApp()));
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeNavigator(),
    );
  }
}

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [BookListPage(), AnalyticsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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

/// Navigation helpers (optional)
void navigateToBookDetail(BuildContext context, Book book) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
  );
}

void navigateToReadingSession(BuildContext context, String bookId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ReadingSessionPage(bookId: bookId)),
  );
}

void navigateToAnalytics(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AnalyticsPage()),
  );
}
