import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/theme/dojo_colors.dart';
import 'package:docklands_dojo/widgets/belt_color_swatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeltColorSwatch', () {
    Widget buildTestWidget({
      required Color primaryColor,
      Color? stripeColor,
      String label = 'Test Belt',
      bool showLabel = true,
      double height = 32,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 100,
              child: BeltColorSwatch(
                primaryColor: primaryColor,
                stripeColor: stripeColor,
                label: label,
                showLabel: showLabel,
                height: height,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders with solid color and label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(primaryColor: DojoColors.beltOrange, label: 'Orange'),
      );

      expect(find.text('Orange'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BeltColorSwatch),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders stripe for kyu8 (orange + blue)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          primaryColor: DojoColors.beltOrange,
          stripeColor: DojoColors.stripeBlue,
          label: 'Orange with Blue stripe',
        ),
      );

      expect(find.text('Orange with Blue stripe'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(BeltColorSwatch),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders stripe for kyu6 (blue + yellow)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          primaryColor: DojoColors.beltBlue,
          stripeColor: DojoColors.stripeYellow,
          label: 'Blue with Yellow stripe',
        ),
      );

      expect(find.text('Blue with Yellow stripe'), findsOneWidget);
    });

    testWidgets('renders stripe for kyu4 (yellow + green)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          primaryColor: DojoColors.beltYellow,
          stripeColor: DojoColors.stripeGreen,
          label: 'Yellow with Green stripe',
        ),
      );

      expect(find.text('Yellow with Green stripe'), findsOneWidget);
    });

    testWidgets('renders without stripe for solid belts', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(primaryColor: DojoColors.beltBrown, label: 'Brown'),
      );

      expect(find.text('Brown'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          primaryColor: DojoColors.beltOrange,
          label: 'Orange',
          showLabel: false,
        ),
      );

      expect(find.text('Orange'), findsNothing);
    });

    testWidgets('provides accessibility semantics', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(primaryColor: DojoColors.beltOrange, label: 'Orange'),
      );

      final semantics = tester.getSemantics(find.byType(BeltColorSwatch));
      expect(semantics.label, contains('Orange Belt'));
    });

    testWidgets('white belt gets border on light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                child: BeltColorSwatch(
                  primaryColor: DojoColors.beltWhite,
                  label: 'White',
                ),
              ),
            ),
          ),
        ),
      );

      // Find the container with border.
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(BeltColorSwatch),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNotNull);
    });

    testWidgets('black belt does not get border on light theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                child: BeltColorSwatch(
                  primaryColor: DojoColors.beltBlack,
                  label: 'Black',
                ),
              ),
            ),
          ),
        ),
      );

      // Black belt should not need a border (low luminance).
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(BeltColorSwatch),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNull);
    });

    testWidgets('custom height is applied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          primaryColor: DojoColors.beltGreen,
          label: 'Green',
          height: 48,
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(BeltColorSwatch),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.constraints?.maxHeight, 48);
    });

    testWidgets('renders all 11 IKO-1 belt colors correctly', (tester) async {
      for (final rank in BeltRank.values) {
        await tester.pumpWidget(
          buildTestWidget(
            primaryColor: rank.primaryColor,
            stripeColor: rank.stripeColor,
            label: rank.colorDescription,
          ),
        );

        expect(find.text(rank.colorDescription), findsOneWidget);
      }
    });

    testWidgets('striped belts have stripe colors from IKO-1 standard', (
      tester,
    ) async {
      // kyu8: Orange + Blue stripe
      expect(BeltRank.kyu8.hasStripe, isTrue);
      expect(BeltRank.kyu8.stripeColor, DojoColors.stripeBlue);

      // kyu6: Blue + Yellow stripe
      expect(BeltRank.kyu6.hasStripe, isTrue);
      expect(BeltRank.kyu6.stripeColor, DojoColors.stripeYellow);

      // kyu4: Yellow + Green stripe
      expect(BeltRank.kyu4.hasStripe, isTrue);
      expect(BeltRank.kyu4.stripeColor, DojoColors.stripeGreen);

      // All other belts are solid.
      for (final rank in BeltRank.values) {
        if (rank != BeltRank.kyu8 &&
            rank != BeltRank.kyu6 &&
            rank != BeltRank.kyu4) {
          expect(
            rank.hasStripe,
            isFalse,
            reason: '${rank.name} should not have a stripe',
          );
        }
      }
    });
  });
}
