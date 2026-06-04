import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the current [ThemeMode].
///
/// Defaults to [ThemeMode.system] and allows toggling between
/// system, light, and dark modes from the settings screen.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
