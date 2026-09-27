import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/presentation/admin/viewmodels/admin_auth_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    registerTestFallbacks();
    mockAuthRepository = MockAuthRepository();
    when(() => mockAuthRepository.getCurrentSession())
        .thenAnswer((_) async => null);
  });

  group('AdminAuthViewModel Tests', () {
    test('Initial state is idle, unauthenticated with no errors', () async {
      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );

      expect(vm.viewState, ViewState.idle);
      expect(vm.isAuthenticated, isFalse);
      expect(vm.currentSession, isNull);
      expect(vm.errorMessage, isEmpty);
      expect(vm.username, isEmpty);
      expect(vm.password, isEmpty);
      expect(vm.usernameError, isNull);
      expect(vm.passwordError, isNull);
    });

    test('Initializes with existing valid session', () async {
      final AuthSession activeSession = AuthSession(
        token: 'active_token',
        username: 'admin',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 2)),
      );
      when(() => mockAuthRepository.getCurrentSession())
          .thenAnswer((_) async => activeSession);

      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );
      await pumpEventQueue();

      expect(vm.isAuthenticated, isTrue);
      expect(vm.currentSession, equals(activeSession));
    });

    test('Validates empty inputs on login attempt', () async {
      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );

      final bool success = await vm.login();

      expect(success, isFalse);
      expect(vm.usernameError, isNotNull);
      expect(vm.passwordError, isNotNull);
      verifyNever(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ));
    });

    test('Clears field errors when input changes', () async {
      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );

      await vm.login();
      expect(vm.usernameError, isNotNull);
      expect(vm.passwordError, isNotNull);

      vm.setUsername('admin');
      expect(vm.usernameError, isNull);

      vm.setPassword('secret');
      expect(vm.passwordError, isNull);
    });

    test('Logs in successfully with valid credentials', () async {
      final AuthSession session = AuthSession(
        token: 'auth_jwt_token',
        username: 'admin',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 4)),
      );
      when(() => mockAuthRepository.login(
            username: 'admin',
            password: 'correct_password',
          )).thenAnswer((_) async => Success<AuthSession>(session));

      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );

      vm.setUsername('admin');
      vm.setPassword('correct_password');

      final bool result = await vm.login();

      expect(result, isTrue);
      expect(vm.viewState, ViewState.success);
      expect(vm.isAuthenticated, isTrue);
      expect(vm.currentSession, equals(session));
      expect(vm.password, isEmpty); // Cleared for security
      expect(vm.errorMessage, isEmpty);
    });

    test('Handles login failure with error state and message', () async {
      when(() => mockAuthRepository.login(
            username: 'admin',
            password: 'wrong_password',
          )).thenAnswer((_) async =>
          const FailureResult<AuthSession>(AuthFailure('Invalid credentials')));

      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );

      vm.setUsername('admin');
      vm.setPassword('wrong_password');

      final bool result = await vm.login();

      expect(result, isFalse);
      expect(vm.viewState, ViewState.error);
      expect(vm.isAuthenticated, isFalse);
      expect(vm.errorMessage, 'Invalid credentials');
    });

    test('Logout clears session and resets state', () async {
      final AuthSession session = AuthSession(
        token: 'token',
        username: 'admin',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      when(() => mockAuthRepository.getCurrentSession())
          .thenAnswer((_) async => session);
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Success<void>(null));

      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );
      await pumpEventQueue();
      expect(vm.isAuthenticated, isTrue);

      await vm.logout();

      expect(vm.isAuthenticated, isFalse);
      expect(vm.currentSession, isNull);
      expect(vm.viewState, ViewState.idle);
      verify(() => mockAuthRepository.logout()).called(1);
    });

    test('toggleObscurePassword toggles password visibility', () {
      final AdminAuthViewModel vm = AdminAuthViewModel(
        authRepository: mockAuthRepository,
      );

      expect(vm.obscurePassword, isTrue);
      vm.toggleObscurePassword();
      expect(vm.obscurePassword, isFalse);
      vm.toggleObscurePassword();
      expect(vm.obscurePassword, isTrue);
    });
  });
}
