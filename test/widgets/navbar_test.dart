import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/nav/sticky_navbar.dart';
import 'package:follio/presentation/widgets/nav/theme_toggle_button.dart';

import '../helpers/pump_app.dart';

void main() {
  group('StickyNavbar Widget Tests', () {
    testWidgets('renders desktop navbar with logo, all nav links, and hire me button',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const StickyNavbar(),
        size: const Size(1280, 800),
      );

      // Logo
      expect(find.text(AppStrings.logoFirst), findsOneWidget);
      expect(find.text(AppStrings.logoAccent), findsOneWidget);

      // Desktop Nav Links
      expect(find.text(AppStrings.navServices), findsOneWidget);
      expect(find.text(AppStrings.navWork), findsOneWidget);
      expect(find.text(AppStrings.navAbout), findsOneWidget);
      expect(find.text(AppStrings.navReviews), findsOneWidget);
      expect(find.text(AppStrings.navBlog), findsOneWidget);
      expect(find.text(AppStrings.navContact), findsOneWidget);

      // Theme toggle & CTA
      expect(find.byType(ThemeToggleButton), findsOneWidget);
      expect(find.text(AppStrings.navHireMe), findsOneWidget);
    });

    testWidgets('collapses to hamburger menu on mobile screen width',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const StickyNavbar(),
        size: const Size(480, 800),
      );

      // Logo is still present
      expect(find.text(AppStrings.logoFirst), findsOneWidget);
      expect(find.text(AppStrings.logoAccent), findsOneWidget);

      // Desktop nav links are collapsed
      expect(find.text(AppStrings.navServices), findsNothing);
      expect(find.text(AppStrings.navHireMe), findsNothing);

      // Hamburger button is rendered
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byType(ThemeToggleButton), findsOneWidget);
    });

    testWidgets('tapping hamburger opens mobile menu',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const StickyNavbar(),
        size: const Size(480, 800),
      );

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Mobile menu drawer is expanded
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text(AppStrings.navServices), findsOneWidget);
    });
  });
}
