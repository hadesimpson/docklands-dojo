import 'package:flutter/material.dart';

import 'app.dart';

/// Entry point for Docklands Dojo.
///
/// Drift database initialization will be added in CL3.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DojoApp());
}
