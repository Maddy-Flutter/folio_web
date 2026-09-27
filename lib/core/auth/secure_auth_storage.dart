import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/auth/auth_storage.dart';

/// Native mobile & desktop implementation of [AuthStorage] backed by Keystore/Keychain.
final class SecureAuthStorage implements AuthStorage {
  SecureAuthStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const String _sessionKey = 'folio_admin_secure_session';

  @override
  Future<void> saveSession(AuthSession session) async {
    final String raw = jsonEncode(session.toJson());
    await _storage.write(key: _sessionKey, value: raw);
  }

  @override
  Future<AuthSession?> getSession() async {
    final String? raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      final AuthSession session = AuthSession.fromJson(json);
      if (session.isExpired) {
        await clearSession();
        return null;
      }
      return session;
    } catch (_) {
      await clearSession();
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
  }
}
