import 'package:follio/core/auth/auth_session.dart';

abstract interface class AuthStorage {
  Future<void> saveSession(AuthSession session);
  Future<AuthSession?> getSession();
  Future<void> clearSession();
}
