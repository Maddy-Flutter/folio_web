import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/core/theme/app_theme.dart';
import 'package:follio/di/app_providers.dart';
import 'package:follio/presentation/admin/views/admin_login_view.dart';
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

    when(() => mockAuthRepo.getCurrentSession())
        .thenAnswer((_) async => null);
    when(() => mockThemeRepo.getSavedThemeMode())
        .thenAnswer((_) async => ThemeMode.dark);
    when(() => mockThemeRepo.saveThemeMode(any()))
        .thenAnswer((_) async {});
  });

  Widget buildLoginTestApp({
    String initialLocation = '/admin/login',
  }) {
    final GoRouter router = GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        GoRoute(
          path: '/admin/login',
          builder: (BuildContext context, GoRouterState state) =>
              const AdminLoginView(),
        ),
        GoRoute(
          path: '/admin/dashboard',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Text('Dashboard View')),
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

  group('AdminLoginView Widget Tests', () {
    testWidgets('Renders login view header, fields, and submit button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Folio'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign in to Console'), findsOneWidget);
    });

    testWidgets('Shows validation errors on empty submit',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildLoginTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in to Console'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your admin username.'), findsOneWidget);
      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('Logs in successfully and routes to dashboard',
        (WidgetTester tester) async {
      final AuthSession session = AuthSession(
        token: 'admin_test_token',
        username: 'Madhavan',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
      );

      when(() => mockAuthRepo.login(
            username: 'Madhavan',
            password: 'secretPassword',
          )).thenAnswer((_) async => Success<AuthSession>(session));

      await tester.pumpWidget(buildLoginTestApp());
      await tester.pumpAndSettle();

      // Enter username & password
      await tester.enterText(
        find.widgetWithText(TextField, 'e.g. Madhavan'),
        'Madhavan',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter password'),
        'secretPassword',
      );
      await tester.pump();

      await tester.tap(find.text('Sign in to Console'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard View'), findsOneWidget);
    });

    testWidgets('Displays error banner when credentials are invalid',
        (WidgetTester tester) async {
      when(() => mockAuthRepo.login(
            username: 'Madhavan',
            password: 'wrongPassword',
          )).thenAnswer((_) async =>
          const FailureResult<AuthSession>(AuthFailure('Invalid admin credentials.')));

      await tester.pumpWidget(buildLoginTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'e.g. Madhavan'),
        'Madhavan',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter password'),
        'wrongPassword',
      );
      await tester.pump();

      await tester.tap(find.text('Sign in to Console'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid admin credentials.'), findsOneWidget);
    });
  });
}
