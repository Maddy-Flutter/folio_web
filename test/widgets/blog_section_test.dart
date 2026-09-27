import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/widgets/blog/blog_post_card.dart';
import 'package:follio/presentation/widgets/blog/blog_section.dart';

import '../helpers/mock_repositories.dart';
import '../helpers/pump_app.dart';

void main() {
  group('BlogSection Widget Tests', () {
    testWidgets('renders section header, blog post cards, and all posts link',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const BlogSection(),
        size: const Size(1280, 900),
      );
      await tester.pump();

      // Section header
      expect(find.text(AppStrings.blogCategory.toUpperCase()), findsOneWidget);
      expect(find.text(AppStrings.blogTitle), findsOneWidget);
      expect(find.text(AppStrings.blogAllLink), findsOneWidget);

      // Blog post cards
      expect(find.byType(BlogPostCard), findsNWidgets(testBlogPosts.length));
      expect(find.text(testBlogPosts.first.title), findsOneWidget);
    });

    testWidgets('tapping All articles link navigates to /blog',
        (WidgetTester tester) async {
      await pumpTestableWidget(
        tester,
        const BlogSection(),
        size: const Size(1280, 900),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.blogAllLink));
      await tester.pumpAndSettle();

      expect(find.text('Blog Page Mock'), findsOneWidget);
    });
  });
}
