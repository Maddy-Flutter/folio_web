import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/app.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/di/app_providers.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/mock_repositories.dart';

void main() {
  late MockPortfolioRepository mockPortfolioRepo;
  late MockContactRepository mockContactRepo;
  late MockThemeRepository mockThemeRepo;

  setUp(() {
    registerTestFallbacks();
    if (!FlavorConfig.isInitialized) {
      FlavorConfig.initialize(flavor: Flavor.user);
    }
    mockPortfolioRepo = MockPortfolioRepository();
    mockContactRepo = MockContactRepository();
    mockThemeRepo = MockThemeRepository();

    when(() => mockPortfolioRepo.getServices())
        .thenAnswer((_) async => Success<List<ServiceModel>>(testServices));
    when(() => mockPortfolioRepo.getProjects())
        .thenAnswer((_) async => Success<List<ProjectModel>>(testProjects));
    when(() => mockPortfolioRepo.getTestimonials())
        .thenAnswer((_) async => Success<List<TestimonialModel>>(testTestimonials));
    when(() => mockPortfolioRepo.getBlogPosts())
        .thenAnswer((_) async => Success<List<BlogPostModel>>(testBlogPosts));
    when(() => mockThemeRepo.getSavedThemeMode())
        .thenAnswer((_) async => ThemeMode.dark);
    when(() => mockThemeRepo.saveThemeMode(any()))
        .thenAnswer((_) async {});
  });

  testWidgets('PortfolioApp renders home sections without error', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      AppProviders(
        portfolioRepository: mockPortfolioRepo,
        contactRepository: mockContactRepo,
        themeRepository: mockThemeRepo,
        child: const PortfolioApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('eli'), findsOneWidget);
    expect(find.text('ott'), findsOneWidget);
  });
}
