import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/book_list/book_list_page.dart';

void main() {
  runApp(const ProviderScope(child: BookTrackerApp()));
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BookListPage(),
    );
  }
}
