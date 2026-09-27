import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/router/auth_guard.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_repositories.dart';

class MockBuildContext extends Mock implements BuildContext {}
class MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late MockBuildContext mockContext;
  late MockGoRouterState mockState;
  late MockAuthStorage mockAuthStorage;

  setUp(() {
    registerTestFallbacks();
    mockContext = MockBuildContext();
    mockState = MockGoRouterState();
    mockAuthStorage = MockAuthStorage();
  });

  group('AuthGuard Tests - User Flavor', () {
    setUp(() {
      FlavorConfig.initialize(flavor: Flavor.user);
    });

    test('Redirects to /404 if User flavor attempts to access /admin routes', () async {
      when(() => mockState.uri).thenReturn(Uri.parse('/admin/login'));

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, '/404');
    });

    test('Allows public portfolio paths for User flavor without redirect', () async {
      when(() => mockState.uri).thenReturn(Uri.parse('/'));

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, isNull);
    });
  });

  group('AuthGuard Tests - Admin Flavor', () {
    setUp(() {
      FlavorConfig.initialize(flavor: Flavor.admin);
    });

    test('Redirects non-admin paths to /admin/login', () async {
      when(() => mockState.uri).thenReturn(Uri.parse('/projects'));

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, '/admin/login');
    });

    test('Allows access to /admin/login when unauthenticated', () async {
      when(() => mockState.uri).thenReturn(Uri.parse('/admin/login'));
      when(() => mockAuthStorage.getSession()).thenAnswer((_) async => null);

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, isNull);
    });

    test('Redirects protected /admin/* route to /admin/login when session is missing', () async {
      when(() => mockState.uri).thenReturn(Uri.parse('/admin/dashboard'));
      when(() => mockAuthStorage.getSession()).thenAnswer((_) async => null);

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, '/admin/login');
    });

    test('Redirects protected /admin/* route to /admin/login when session is expired', () async {
      final AuthSession expiredSession = AuthSession(
        token: 'expired_tok',
        username: 'admin',
        issuedAt: DateTime.now().subtract(const Duration(hours: 10)),
        expiresAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      when(() => mockState.uri).thenReturn(Uri.parse('/admin/dashboard'));
      when(() => mockAuthStorage.getSession()).thenAnswer((_) async => expiredSession);

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, '/admin/login');
    });

    test('Redirects authenticated user from /admin/login to /admin/dashboard', () async {
      final AuthSession validSession = AuthSession(
        token: 'valid_tok',
        username: 'admin',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 4)),
      );

      when(() => mockState.uri).thenReturn(Uri.parse('/admin/login'));
      when(() => mockAuthStorage.getSession()).thenAnswer((_) async => validSession);

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, '/admin/dashboard');
    });

    test('Allows authenticated user to access protected /admin/dashboard', () async {
      final AuthSession validSession = AuthSession(
        token: 'valid_tok',
        username: 'admin',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 4)),
      );

      when(() => mockState.uri).thenReturn(Uri.parse('/admin/dashboard'));
      when(() => mockAuthStorage.getSession()).thenAnswer((_) async => validSession);

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, isNull);
    });

    test('Allows authenticated user to access protected /admin/messages', () async {
      final AuthSession validSession = AuthSession(
        token: 'valid_tok',
        username: 'admin',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 4)),
      );

      when(() => mockState.uri).thenReturn(Uri.parse('/admin/messages'));
      when(() => mockAuthStorage.getSession()).thenAnswer((_) async => validSession);

      final String? redirect = await AuthGuard.redirect(
        context: mockContext,
        state: mockState,
        authStorage: mockAuthStorage,
      );

      expect(redirect, isNull);
    });
  });
}
