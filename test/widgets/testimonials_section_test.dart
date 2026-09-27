import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/testimonials/testimonial_card.dart';
import 'package:follio/presentation/widgets/testimonials/testimonials_section.dart';

import '../helpers/mock_repositories.dart';
import '../helpers/pump_app.dart';

void main() {
  group('TestimonialsSection Widget Tests', () {
    testWidgets('renders section header and testimonial cards with names and quotes',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const TestimonialsSection(),
        size: const Size(1280, 900),
      );
      await tester.pump();

      // Section header
      expect(find.text(AppStrings.reviewsCategory.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.reviewsTitle), findsOneWidget);

      // Testimonial cards
      expect(find.byType(TestimonialCard), findsNWidgets(testTestimonials.length));

      for (final t in testTestimonials) {
        expect(find.text(t.name), findsOneWidget);
        expect(find.textContaining(t.quote), findsOneWidget);
      }
    });
  });
}
