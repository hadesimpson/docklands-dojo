# 🥋 Docklands Dojo

A Kyokushin Karate training app built with Flutter — track belt progression, master Japanese terminology through spaced repetition, and prepare for gradings with self-assessment quizzes.

**Syllabus Standard**: IKO-1 (International Karate Organization, founded by Sosai Mas Oyama).

## Features

- **Belt Progression** — Visual journey from 10th Kyu (White) to Shodan (Black Belt) with IKO-1 requirements
- **Technique Library** — 100+ techniques across 9 categories with Japanese terminology
- **Spaced Repetition** — SM-2 algorithm flashcards for terminology mastery
- **Grading Quizzes** — Self-assessment with mock exam mode and readiness tracking
- **Data Export/Import** — Progress portability via JSON export
- **Dark Mode** — System, light, and dark theme toggle via settings
- **Accessibility** — Semantic labels on all interactive elements, text labels for all color indicators
- **Home Dashboard** — Quick access to review, quiz, belt progression, and technique library

## Architecture

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart 3.x) |
| State Management | Riverpod 3.x (@riverpod code generation) |
| Local Storage | Drift 2.x (SQLite) |
| Navigation | GoRouter |
| Design System | Material 3 + custom "Dojo" theme |
| Animations | flutter_animate |
| Testing | flutter_test + mocktail |
| Content | Static Dart files (AI-generated, expert-validated) |
| CI/CD | GitHub Actions |
| Fonts | Bundled as assets (offline-first, no google_fonts) |

## Setup

```bash
# Clone the repo
git clone https://github.com/hadesimpson/docklands-dojo.git
cd docklands-dojo

# Install dependencies
flutter pub get

# Generate code (Drift, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Analyze
flutter analyze
```

## Project Structure

```
lib/
├── main.dart              # Entry point
├── app.dart               # MaterialApp.router + GoRouter
├── result.dart            # Result<T> sealed type (Success/Failure)
├── theme/
│   ├── dojo_theme.dart    # Material 3 theme (light + dark)
│   └── dojo_colors.dart   # Color constants (belts + UI)
├── models/                # Domain models (BeltRank, Technique, Kata, etc.)
├── database/              # Drift (SQLite) database + DAOs
├── data/                  # Static content (techniques, kata, syllabus)
├── services/              # Business logic (returns Result<T>)
├── providers/             # @riverpod generated providers
└── screens/               # UI screens organized by feature
```

## Design Philosophy

- **Offline-first**: Zero cloud dependency, all data stored locally via Drift
- **Content safety**: AI generates content, expert validates — wrong technique descriptions can cause injury
- **IKO-1 accuracy**: Belt colors, requirements, and terminology follow IKO-1 standard
- **Error resilience**: All services return `Result<T>`, UI never crashes

## Belt Color System (IKO-1)

| Rank | Color | Stripe |
|------|-------|--------|
| 10th Kyu | White | — |
| 9th Kyu | Orange | — |
| 8th Kyu | Orange | Blue |
| 7th Kyu | Blue | — |
| 6th Kyu | Blue | Yellow |
| 5th Kyu | Yellow | — |
| 4th Kyu | Yellow | Green |
| 3rd Kyu | Green | — |
| 2nd Kyu | Brown | — |
| 1st Kyu | Brown | — |
| Shodan | Black | — |

## License

Private project — All rights reserved.
