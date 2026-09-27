import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/contact/contact_form.dart';
import 'package:follio/presentation/widgets/contact/contact_section.dart';
import 'package:follio/presentation/widgets/contact/contact_success_panel.dart';

import '../helpers/pump_app.dart';

void main() {
  group('ContactSection Widget Tests', () {
    testWidgets('renders intro content and contact form by default',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const ContactSection(),
      );
      await tester.pump();

      // Intro
      expect(find.text(AppStrings.contactCategory.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.contactTitle), findsOneWidget);
      expect(find.text(AppStrings.contactIntro), findsOneWidget);

      // Form
      expect(find.byType(ContactForm), findsOneWidget);
      expect(find.text('${AppStrings.formNameLabel} *'), findsOneWidget);
      expect(find.text('${AppStrings.formEmailLabel} *'), findsOneWidget);
      expect(find.text(AppStrings.formSubjectLabel), findsOneWidget);
      expect(find.text('${AppStrings.formMessageLabel} *'), findsOneWidget);
      expect(find.text(AppStrings.formSubmitButton), findsOneWidget);
    });

    testWidgets('submitting valid form shows success panel',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const ContactSection(),
        size: const Size(1280, 1200),
      );
      await tester.pump();

      final Finder nameField = find.byWidgetPredicate(
        (Widget w) => w is TextField && w.decoration?.hintText == AppStrings.formNamePlaceholder,
      );
      final Finder emailField = find.byWidgetPredicate(
        (Widget w) => w is TextField && w.decoration?.hintText == AppStrings.formEmailPlaceholder,
      );
      final Finder subjectField = find.byWidgetPredicate(
        (Widget w) => w is TextField && w.decoration?.hintText == AppStrings.formSubjectPlaceholder,
      );
      final Finder messageField = find.byWidgetPredicate(
        (Widget w) => w is TextField && w.decoration?.hintText == AppStrings.formMessagePlaceholder,
      );

      expect(nameField, findsOneWidget);
      expect(emailField, findsOneWidget);
      expect(subjectField, findsOneWidget);
      expect(messageField, findsOneWidget);

      await tester.enterText(nameField, 'Jane Doe');
      await tester.enterText(emailField, 'jane.doe@company.com');
      await tester.enterText(subjectField, 'New Website Project');
      await tester.enterText(
        messageField,
        'Hello Eliott, we would love to collaborate on our upcoming product redesign.',
      );
      await tester.pump();

      // Tap submit button
      await tester.tap(find.text(AppStrings.formSubmitButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Success panel should now be visible
      expect(find.byType(ContactSuccessPanel), findsOneWidget);
      expect(find.text(AppStrings.successTitle), findsOneWidget);
    });
  });
}
