import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/services/service_card.dart';
import 'package:follio/presentation/widgets/services/services_section.dart';

import '../helpers/mock_repositories.dart';
import '../helpers/pump_app.dart';

void main() {
  group('ServicesSection Widget Tests', () {
    testWidgets('renders section header and 3 service cards on desktop',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const ServicesSection(),
        size: const Size(1280, 900),
      );
      await tester.pump();

      // Section header
      expect(find.text(AppStrings.servicesCategory.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.servicesTitle), findsOneWidget);

      // Service cards
      expect(find.byType(ServiceCard), findsNWidgets(testServices.length));
      for (final service in testServices) {
        expect(find.text(service.title), findsOneWidget);
        expect(find.text(service.description), findsOneWidget);
      }
    });

    testWidgets('renders service cards vertically on mobile screen',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const ServicesSection(),
        size: const Size(480, 1000),
      );
      await tester.pump();

      expect(find.byType(ServiceCard), findsNWidgets(testServices.length));
      expect(find.text(testServices.first.title), findsOneWidget);
    });
  });
}
