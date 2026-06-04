# Plan — Docklands Dojo QA Deep Pass

## Architecture
Flutter app: Drift (SQLite) + Riverpod + GoRouter
Source: /usr/local/google/home/adesimpson/docklands-dojo/lib/
Tests: /usr/local/google/home/adesimpson/docklands-dojo/test/

## Milestones

| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| M1 | Test Fix + Analyzer | R1 (13 failing tests), R2 (43 analyzer issues) | none | PLANNED |
| M2 | Logic Bug Audit | R3 (SM-2, quiz, belt, search, export) | none | PLANNED |
| M3 | UI + Content + Perf | R4 (UI), R5 (IKO-1 content), R6 (performance) | none | PLANNED |
| M4 | Build + Final Report | R7 (build verification), summary | M1, M2, M3 | PLANNED |

## Strategy
- M1, M2, M3 run in parallel — each gets an Explorer then Worker
- M4 runs after all 3 complete — final verification pass
- All workers share the same workspace (changes are to different files)

## Key Files by Milestone
### M1 (Tests + Analyzer)
- test/screens/belt_progression/belt_list_screen_test.dart
- test/screens/review/flashcard_screen_test.dart
- lib/screens/belt_progression/belt_list_screen.dart
- lib/screens/belt_progression/belt_detail_screen.dart
- lib/screens/review/flashcard_screen.dart
- lib/screens/home/home_screen.dart, dashboard_card.dart
- lib/screens/quiz/quiz_config_screen.dart
- lib/widgets/belt_color_swatch.dart
- test/widgets/belt_color_swatch_test.dart

### M2 (Logic Bugs)
- lib/services/srs/sm2_algorithm.dart
- lib/services/quiz_service.dart
- lib/services/progress_service.dart
- lib/services/search_service.dart
- lib/services/fuzzy_match_service.dart
- lib/services/export_service.dart

### M3 (UI + Content + Perf)
- lib/data/syllabus_data.dart
- lib/data/techniques_data.dart
- lib/data/kata_data.dart
- lib/data/flashcards_data.dart
- lib/providers/*.dart
- lib/screens/**/*.dart
