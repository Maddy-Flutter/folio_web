import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/work/compact_project_card.dart';
import 'package:follio/presentation/widgets/work/featured_project_card.dart';
import 'package:follio/presentation/widgets/work/selected_work_section.dart';

import '../helpers/mock_repositories.dart';
import '../helpers/pump_app.dart';

void main() {
  group('SelectedWorkSection Widget Tests', () {
    testWidgets('renders section header, featured card, and compact cards',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const SelectedWorkSection(),
      );
      await tester.pump();

      // Header and "All projects" link
      expect(find.text(AppStrings.workCategory.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.workTitle), findsOneWidget);
      expect(find.text(AppStrings.workAllLink), findsOneWidget);

      // Featured card
      expect(find.byType(FeaturedProjectCard), findsOneWidget);
      expect(find.text(testProjects.first.title), findsOneWidget);

      // Compact card
      expect(find.byType(CompactProjectCard), findsOneWidget);
      expect(find.text(testProjects[1].title), findsOneWidget);
    });

    testWidgets('tapping All Projects link navigates to projects route',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const SelectedWorkSection(),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.workAllLink));
      await tester.pumpAndSettle();

      expect(find.text('Projects Page Mock'), findsOneWidget);
    });
  });
}
