import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/common/animated_counter.dart';
import 'package:follio/presentation/widgets/hero/hero_section.dart';

import '../helpers/pump_app.dart';

void main() {
  group('HeroSection Widget Tests', () {
    testWidgets('renders greeting, name, CTAs, and animated stat counters',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const HeroSection(),
      );

      // Pill badge
      expect(find.text(AppStrings.heroAvailableBadge.toUpperCase()), findsOneWidget);

      // Headline (RichText)
      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(AppStrings.heroGreeting) &&
              widget.text.toPlainText().contains(AppStrings.heroName),
        ),
        findsOneWidget,
      );

      // CTAs
      expect(find.text(AppStrings.heroCtaWork), findsOneWidget);
      expect(find.text(AppStrings.heroCtaContact), findsOneWidget);

      // Stat counters
      expect(find.byType(AnimatedCounter), findsNWidgets(3));
      expect(find.text(AppStrings.statProjectsDoneLabel), findsOneWidget);
      expect(find.text(AppStrings.statHappyClientsLabel), findsOneWidget);
      expect(find.text(AppStrings.statExperienceLabel), findsOneWidget);

      // Open to projects badge
      expect(find.text(AppStrings.heroOpenToProjects), findsOneWidget);
    });
  });
}
