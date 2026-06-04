import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/quiz.dart';
import 'package:docklands_dojo/providers/theme_provider.dart';
import 'package:docklands_dojo/screens/belt_progression/belt_detail_screen.dart';
import 'package:docklands_dojo/screens/belt_progression/belt_list_screen.dart';
import 'package:docklands_dojo/screens/home/home_screen.dart';
import 'package:docklands_dojo/screens/quiz/quiz_config_screen.dart';
import 'package:docklands_dojo/screens/quiz/quiz_screen.dart';
import 'package:docklands_dojo/screens/review/flashcard_screen.dart';
import 'package:docklands_dojo/screens/settings/settings_screen.dart';
import 'package:docklands_dojo/screens/technique/technique_library_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'theme/dojo_theme.dart';

/// The root widget of the Docklands Dojo app.
///
/// Configures [MaterialApp.router] with [GoRouter] for declarative
/// navigation and the Dojo Material 3 theme (light + dark).
///
/// Watches [themeModeProvider] to reactively switch between
/// system, light, and dark modes.
class DojoApp extends ConsumerWidget {
  /// Optional router override for testing.
  final GoRouter? router;

  /// Creates the [DojoApp] root widget.
  const DojoApp({this.router, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Docklands Dojo',
      debugShowCheckedModeBanner: false,
      theme: DojoTheme.light(),
      darkTheme: DojoTheme.dark(),
      themeMode: themeMode,
      routerConfig: router ?? dojoRouter,
    );
  }
}

/// Global navigator key for GoRouter.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Shell navigator key for bottom navigation.
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// The main GoRouter configuration for Docklands Dojo.
///
/// Uses a [ShellRoute] for bottom navigation with 4 tabs:
/// Home, Techniques, Review, and Progress (Belt Progression).
///
/// Additional routes for quiz, settings, and belt detail are
/// defined outside the shell.
final GoRouter dojoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Bottom navigation shell.
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavigationShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/techniques',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TechniqueLibraryScreen()),
        ),
        GoRoute(
          path: '/review',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FlashcardScreen()),
        ),
        GoRoute(
          path: '/belts',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: BeltListScreen()),
        ),
      ],
    ),

    // Routes outside the bottom nav shell.
    GoRoute(
      path: '/belt/:rank',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final rankName = state.pathParameters['rank'] ?? 'kyu10';
        final rank = BeltRank.values.firstWhere(
          (r) => r.name == rankName,
          orElse: () => BeltRank.kyu10,
        );
        return BeltDetailScreen(rank: rank);
      },
    ),
    GoRoute(
      path: '/quiz',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => QuizConfigScreen(
        onStartQuiz: (config) {
          _rootNavigatorKey.currentContext?.pushNamed(
            'quiz-active',
            extra: config,
          );
        },
      ),
    ),
    GoRoute(
      path: '/quiz/active',
      name: 'quiz-active',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final config =
            state.extra as QuizConfig? ??
            const QuizConfig(targetRank: BeltRank.kyu10);
        return QuizScreen(config: config);
      },
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

/// Bottom navigation shell widget.
///
/// Provides the persistent [NavigationBar] with 4 tabs:
/// Home, Techniques, Review, and Belt Progression.
class NavigationShell extends StatefulWidget {
  /// The child widget from the current route.
  final Widget child;

  /// Creates a [NavigationShell].
  const NavigationShell({required this.child, super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  static const _routes = ['/', '/techniques', '/review', '/belts'];

  /// Switches to the tab at [index].
  void switchTab(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    // Sync index with current route.
    final location = GoRouterState.of(context).uri.path;
    final matchedIndex = _routes.indexOf(location);
    if (matchedIndex >= 0 && matchedIndex != _currentIndex) {
      _currentIndex = matchedIndex;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Semantics(
        label: 'Main navigation',
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: switchTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Techniques',
            ),
            NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style),
              label: 'Review',
            ),
            NavigationDestination(
              icon: Icon(Icons.military_tech_outlined),
              selectedIcon: Icon(Icons.military_tech),
              label: 'Belts',
            ),
          ],
        ),
      ),
    );
  }
}
