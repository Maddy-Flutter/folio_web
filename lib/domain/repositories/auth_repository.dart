import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/result/result.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });

  Future<Result<void>> logout();

  Future<AuthSession?> getCurrentSession();
}
