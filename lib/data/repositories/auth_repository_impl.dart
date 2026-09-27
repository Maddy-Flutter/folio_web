import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/admin_auth_data_source.dart';
import 'package:follio/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AdminAuthDataSource authDataSource,
    required AuthStorage authStorage,
  })  : _authDataSource = authDataSource,
        _authStorage = authStorage;

  final AdminAuthDataSource _authDataSource;
  final AuthStorage _authStorage;

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    try {
      final AuthSession session = await _authDataSource.authenticate(
        username: username,
        password: password,
      );
      await _authStorage.saveSession(session);
      return Success<AuthSession>(session);
    } on Failure catch (failure) {
      return FailureResult<AuthSession>(failure);
    } catch (e) {
      return FailureResult<AuthSession>(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authStorage.clearSession();
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    return _authStorage.getSession();
  }
}
