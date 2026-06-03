import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme/dojo_theme.dart';

/// The root widget of the Docklands Dojo app.
///
/// Configures [MaterialApp.router] with [GoRouter] for declarative
/// navigation and the Dojo Material 3 theme (light + dark).
class DojoApp extends StatelessWidget {
  /// Creates the [DojoApp] root widget.
  const DojoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Docklands Dojo',
      debugShowCheckedModeBanner: false,
      theme: DojoTheme.light(),
      darkTheme: DojoTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

/// Placeholder GoRouter configuration.
///
/// Routes will be expanded in subsequent CLs as screens are added.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _PlaceholderHomeScreen(),
    ),
  ],
);

/// Temporary placeholder home screen.
///
/// Will be replaced by the real home screen in CL12.
class _PlaceholderHomeScreen extends StatelessWidget {
  const _PlaceholderHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Docklands Dojo')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Osu! 🥋', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text('Welcome to Docklands Dojo', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
