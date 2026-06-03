import 'package:docklands_dojo/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DojoApp', () {
    testWidgets('launches without crash', (tester) async {
      await tester.pumpWidget(const DojoApp());
      await tester.pumpAndSettle();

      // App should render the placeholder home screen
      expect(find.text('Docklands Dojo'), findsOneWidget);
    });

    testWidgets('displays welcome text', (tester) async {
      await tester.pumpWidget(const DojoApp());
      await tester.pumpAndSettle();

      expect(find.text('Osu! 🥋'), findsOneWidget);
      expect(find.text('Welcome to Docklands Dojo'), findsOneWidget);
    });
  });
}
