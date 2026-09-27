import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/core/theme/app_theme.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/di/app_providers.dart';
import 'package:follio/presentation/admin/views/admin_dashboard_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockThemeRepository mockThemeRepo;
  late MockAnalyticsRepository mockAnalyticsRepo;
  late MockMessagesRepository mockMessagesRepo;

  setUp(() {
    registerTestFallbacks();
    if (!FlavorConfig.isInitialized) {
      FlavorConfig.initialize(flavor: Flavor.admin);
    }
    mockAuthRepo = MockAuthRepository();
    mockThemeRepo = MockThemeRepository();
    mockAnalyticsRepo = MockAnalyticsRepository();
    mockMessagesRepo = MockMessagesRepository();

    final AuthSession activeSession = AuthSession(
      token: 'valid_token',
      username: 'admin',
      issuedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 2)),
    );

    when(() => mockAuthRepo.getCurrentSession())
        .thenAnswer((_) async => activeSession);
    when(() => mockThemeRepo.getSavedThemeMode())
        .thenAnswer((_) async => ThemeMode.dark);
    when(() => mockThemeRepo.saveThemeMode(any()))
        .thenAnswer((_) async {});
  });

  Widget buildDashboardTestApp() {
    final GoRouter router = GoRouter(
      initialLocation: '/admin/dashboard',
      routes: <RouteBase>[
        GoRoute(
          path: '/admin/dashboard',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: AdminDashboardView()),
        ),
        GoRoute(
          path: '/admin/messages',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('Messages Route')),
        ),
        GoRoute(
          path: '/admin/profile-update',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('Profile Update Route')),
        ),
      ],
    );

    return AppProviders(
      flavor: Flavor.admin,
      authRepository: mockAuthRepo,
      themeRepository: mockThemeRepo,
      analyticsRepository: mockAnalyticsRepo,
      messagesRepository: mockMessagesRepo,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }

  group('AdminDashboardView Widget Tests', () {
    testWidgets('Renders skeleton loading state while dashboard data is fetching',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final Completer<Result<AnalyticsSummaryModel>> analyticsCompleter =
          Completer<Result<AnalyticsSummaryModel>>();
      final Completer<Result<List<ContactMessageModel>>> messagesCompleter =
          Completer<Result<List<ContactMessageModel>>>();

      when(() => mockAnalyticsRepo.getSummary())
          .thenAnswer((_) => analyticsCompleter.future);
      when(() => mockMessagesRepo.getMessages(limit: 5))
          .thenAnswer((_) => messagesCompleter.future);

      await tester.pumpWidget(buildDashboardTestApp());
      // Pump once to build widget in loading state without completing the futures
      await tester.pump();

      // Header is visible
      expect(find.text('Admin Dashboard'), findsOneWidget);
      expect(find.text('Update Profile'), findsOneWidget);

      // Loading skeleton containers are displayed, stat card titles are not yet present
      expect(find.text('Messages Received'), findsNothing);
      expect(find.text('Site Visitors'), findsNothing);

      // Finish loading
      analyticsCompleter.complete(const Success<AnalyticsSummaryModel>(testAnalyticsSummary));
      messagesCompleter.complete(Success<List<ContactMessageModel>>(testMessages));
      await tester.pumpAndSettle();

      // Now stat cards and recent messages are rendered
      expect(find.text('Messages Received'), findsOneWidget);
      expect(find.text('Site Visitors'), findsOneWidget);
      expect(find.text('1540'), findsOneWidget);
      expect(find.text('Recent Activity'), findsOneWidget);
    });

    testWidgets('Renders populated dashboard with stat cards and recent activity',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      when(() => mockAnalyticsRepo.getSummary())
          .thenAnswer((_) async => const Success<AnalyticsSummaryModel>(testAnalyticsSummary));
      when(() => mockMessagesRepo.getMessages(limit: 5))
          .thenAnswer((_) async => Success<List<ContactMessageModel>>(testMessages));

      await tester.pumpWidget(buildDashboardTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Admin Dashboard'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Messages Received'), findsOneWidget);
      expect(find.text('Site Visitors'), findsOneWidget);
      expect(find.text('1540'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Recent Activity'), findsOneWidget);
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Project Inquiry'), findsOneWidget);
    });
  });
}
