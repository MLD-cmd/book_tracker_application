# Book Tracker Application

A Flutter application that helps users organize books, track reading progress,
manage reading sessions, and view reading analytics.  
The app uses **Riverpod** for state management and follows a feature-based
architecture.

## Setup Instructions

### Requirements
- Flutter SDK (stable channel)
- Dart SDK
- Windows / Web / Android emulator

### Installation
```bash
git clone https://github.com/MLD-cmd/book_tracker_application.git
cd book_tracker_application
flutter pub get
flutter run 

## Known Issues and Limitations

- Test coverage is currently limited and does not yet meet the 70% target.
  Widget and integration tests are minimal and planned for future improvement.

- Application state is stored in memory only.
  Data such as books, progress, notes, and reading sessions will reset when the
  app is restarted. Persistent storage (e.g., SQLite or SharedPreferences)
  is not yet implemented.

- Reading session history does not track session duration explicitly.
  The timer is displayed in real-time but is not saved as part of session data.

- Error handling is minimal.
  User input validation and edge case handling (e.g., invalid page numbers)
  can be improved.

- UI/UX is optimized for functionality rather than design.
  The app does not currently follow a specific design system or theme.

- The default Flutter widget test template is still present and may fail
  due to differences between the test expectations and the actual app UI.

- The app has not been optimized for large book libraries.
  Performance may degrade with a very large number of books.

- No authentication or user accounts are implemented.
  All data assumes a single local user.

