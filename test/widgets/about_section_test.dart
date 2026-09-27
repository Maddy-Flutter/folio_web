import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/about/about_section.dart';

import '../helpers/pump_app.dart';

void main() {
  group('AboutSection Widget Tests', () {
    testWidgets('renders category, title, bio paragraphs, and stack tool chips',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const AboutSection(),
      );

      // Section titles
      expect(find.text(AppStrings.aboutCategory.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.aboutTitle), findsOneWidget);

      // Bio paragraphs
      expect(find.text(AppStrings.aboutPara1), findsOneWidget);
      expect(find.text(AppStrings.aboutPara2), findsOneWidget);

      // Stack header
      expect(find.text(AppStrings.aboutStackTitle.toUpperCase()), findsOneWidget);

      // Stack chips
      for (final String tool in AppStrings.aboutTools) {
        expect(find.text(tool), findsOneWidget);
      }
    });
  });
}
