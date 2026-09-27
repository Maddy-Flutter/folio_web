import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/core/theme/app_theme.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/di/app_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_repositories.dart';

MockPortfolioRepository createPopulatedPortfolioRepo() {
  registerTestFallbacks();
  final MockPortfolioRepository repo = MockPortfolioRepository();
  when(() => repo.getServices())
      .thenAnswer((_) async => Success<List<ServiceModel>>(testServices));
  when(() => repo.getProjects())
      .thenAnswer((_) async => Success<List<ProjectModel>>(testProjects));
  when(() => repo.getTestimonials())
      .thenAnswer((_) async => Success<List<TestimonialModel>>(testTestimonials));
  when(() => repo.getBlogPosts())
      .thenAnswer((_) async => Success<List<BlogPostModel>>(testBlogPosts));
  when(() => repo.getProjectBySlug(any()))
      .thenAnswer((Invocation inv) async {
    final String slug = inv.positionalArguments.first as String;
    final ProjectModel? p = testProjects.cast<ProjectModel?>().firstWhere(
          (ProjectModel? item) => item?.slug == slug,
          orElse: () => null,
        );
    if (p != null) {
      return Success<ProjectModel>(p);
    }
    return const FailureResult<ProjectModel>(CacheFailure('Not found'));
  });
  when(() => repo.getBlogPostBySlug(any()))
      .thenAnswer((Invocation inv) async {
    final String slug = inv.positionalArguments.first as String;
    final BlogPostModel? b = testBlogPosts.cast<BlogPostModel?>().firstWhere(
          (BlogPostModel? item) => item?.slug == slug,
          orElse: () => null,
        );
    if (b != null) {
      return Success<BlogPostModel>(b);
    }
    return const FailureResult<BlogPostModel>(CacheFailure('Not found'));
  });
  return repo;
}

MockContactRepository createDefaultContactRepo() {
  registerTestFallbacks();
  final MockContactRepository repo = MockContactRepository();
  when(() => repo.submitContactForm(any()))
      .thenAnswer((_) async => const Success<void>(null));
  return repo;
}

MockThemeRepository createDefaultThemeRepo({ThemeMode initial = ThemeMode.dark}) {
  registerTestFallbacks();
  final MockThemeRepository repo = MockThemeRepository();
  when(() => repo.getSavedThemeMode()).thenAnswer((_) async => initial);
  when(() => repo.saveThemeMode(any())).thenAnswer((_) async {});
  return repo;
}

Future<void> pumpTestableWidget(
  WidgetTester tester,
  Widget child, {
  MockPortfolioRepository? portfolioRepo,
  MockContactRepository? contactRepo,
  MockThemeRepository? themeRepo,
  ThemeMode themeMode = ThemeMode.dark,
  Size size = const Size(1280, 1000),
}) async {
  registerTestFallbacks();

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);

  final MockPortfolioRepository effectivePortfolioRepo =
      portfolioRepo ?? createPopulatedPortfolioRepo();
  final MockContactRepository effectiveContactRepo =
      contactRepo ?? createDefaultContactRepo();
  final MockThemeRepository effectiveThemeRepo =
      themeRepo ?? createDefaultThemeRepo(initial: themeMode);

  final GoRouter testRouter = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => Scaffold(
          body: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: '/projects',
        builder: (BuildContext context, GoRouterState state) =>
            const Scaffold(body: Text('Projects Page Mock')),
      ),
      GoRoute(
        path: '/case-study/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            Scaffold(body: Text('Case Study Mock: ${state.pathParameters['slug']}')),
      ),
      GoRoute(
        path: '/blog',
        builder: (BuildContext context, GoRouterState state) =>
            const Scaffold(body: Text('Blog Page Mock')),
      ),
      GoRoute(
        path: '/blog/:slug',
        builder: (BuildContext context, GoRouterState state) =>
            Scaffold(body: Text('Blog Article Mock: ${state.pathParameters['slug']}')),
      ),
    ],
  );

  await tester.pumpWidget(
    AppProviders(
      portfolioRepository: effectivePortfolioRepo,
      contactRepository: effectiveContactRepo,
      themeRepository: effectiveThemeRepo,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: testRouter,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}
