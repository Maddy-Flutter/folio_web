import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/theme/app_theme.dart';
import 'package:follio/di/app_providers.dart';
import 'package:follio/presentation/admin/views/admin_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockThemeRepository mockThemeRepo;

  setUp(() {
    registerTestFallbacks();
    if (!FlavorConfig.isInitialized) {
      FlavorConfig.initialize(flavor: Flavor.admin);
    }
    mockAuthRepo = MockAuthRepository();
    mockThemeRepo = MockThemeRepository();

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

  Widget buildAdminShellTestApp({
    required Widget child,
    required String initialLocation,
    Size size = const Size(1280, 1000),
  }) {
    final GoRouter router = GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return AdminShell(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/admin/dashboard',
              builder: (BuildContext context, GoRouterState state) =>
                  const Scaffold(body: Text('Dashboard Content')),
            ),
            GoRoute(
              path: '/admin/messages',
              builder: (BuildContext context, GoRouterState state) =>
                  const Scaffold(body: Text('Messages Content')),
            ),
            GoRoute(
              path: '/admin/profile-update',
              builder: (BuildContext context, GoRouterState state) =>
                  const Scaffold(body: Text('Profile Content')),
            ),
          ],
        ),
      ],
    );

    return AppProviders(
      flavor: Flavor.admin,
      authRepository: mockAuthRepo,
      themeRepository: mockThemeRepo,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }

  group('AdminShell Widget Tests', () {
    testWidgets('Renders desktop sidebar with navigation items on wide screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildAdminShellTestApp(
          child: const Text('Dashboard Content'),
          initialLocation: '/admin/dashboard',
        ),
      );
      await tester.pumpAndSettle();

      // Brand title
      expect(find.text('Folio'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);

      // Sidebar links
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Profile Update'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);

      // Content
      expect(find.text('Dashboard Content'), findsOneWidget);
    });

    testWidgets('Renders bottom navigation bar on mobile screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildAdminShellTestApp(
          child: const Text('Dashboard Content'),
          initialLocation: '/admin/dashboard',
          size: const Size(400, 800),
        ),
      );
      await tester.pumpAndSettle();

      // Mobile Bottom Navigation Bar destinations
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Tapping sidebar item navigates to destination',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        buildAdminShellTestApp(
          child: const Text('Dashboard Content'),
          initialLocation: '/admin/dashboard',
        ),
      );
      await tester.pumpAndSettle();

      // Click on Messages link in sidebar
      await tester.tap(find.text('Messages'));
      await tester.pumpAndSettle();

      // Messages content rendered
      expect(find.text('Messages Content'), findsOneWidget);
    });
  });
}
