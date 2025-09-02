# SentienWork

A career development and productivity application built with Flutter.

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode for device testing

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/SentienWork.git
cd SentienWork
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
├── models/                   # Data models
├── services/                 # API and business logic
└── utils/                    # Helper functions
```

## Platform Support

- Android
- iOS
- Web

## Development

Run tests:
```bash
flutter test
```

Build for release:
```bash
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## Web Deployment

To build and deploy the web version:

```bash
flutter build web --release
```

The built files will be in the `build/web/` directory, ready for deployment to any web hosting service.

## Features

- Complete onboarding flow with AI companion "Ben"
- Task management with priorities and time scheduling
- Note-taking system
- Journey tracking and goal setting
- Clean, modern UI with Material 3 design
