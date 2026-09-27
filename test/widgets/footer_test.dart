import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/footer/app_footer.dart';

import '../helpers/pump_app.dart';

void main() {
  group('AppFooter Widget Tests', () {
    testWidgets('renders copyright, developer info, and built with attribution on desktop',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const AppFooter(),
        size: const Size(1280, 400),
      );

      expect(find.text(AppStrings.footerCopyright), findsOneWidget);
      expect(find.text(AppStrings.footerDevelopedBy), findsOneWidget);
      expect(find.text(AppStrings.footerBuiltWith), findsOneWidget);
    });

    testWidgets('renders vertically centered attribution on mobile',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const AppFooter(),
        size: const Size(480, 400),
      );

      expect(find.text(AppStrings.footerCopyright), findsOneWidget);
      expect(find.text(AppStrings.footerDevelopedBy), findsOneWidget);
      expect(find.text(AppStrings.footerBuiltWith), findsOneWidget);
    });
  });
}
