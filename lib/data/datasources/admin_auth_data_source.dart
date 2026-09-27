import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/errors/failures.dart';

abstract interface class AdminAuthDataSource {
  Future<AuthSession> authenticate({
    required String username,
    required String password,
  });
}

/// Production-structured authentication data source.
///
/// PLACEHOLDER AUTH SOURCE NOTE:
/// This implementation evaluates credentials by comparing the SHA-256 hash of the input
/// against the expected hash values supplied at build time via `--dart-define=ADMIN_USERNAME_HASH=...`
/// and `--dart-define=ADMIN_PASSWORD_HASH=...`.
///
/// To swap this placeholder for a production auth backend (e.g. Firebase Auth with Custom Claims):
/// 1. Replace the body of [authenticate] with `FirebaseAuth.instance.signInWithEmailAndPassword(...)`.
/// 2. Verify `IdTokenResult.claims['admin'] == true`.
/// 3. Return an [AuthSession] constructed from the Firebase ID token and expiry timestamp.
final class AdminAuthDataSourceImpl implements AdminAuthDataSource {
  const AdminAuthDataSourceImpl({
    this.expectedUsernameHash = _defaultUsernameHash,
    this.expectedPasswordHash = _defaultPasswordHash,
  });

  // Default build-time hashes:
  // "Madhavan" -> 642ed0bca90e038e74de2e45265ead2b5b700642e8a7e9ea02755792c88d73ee
  // "220701"   -> 38d5b2f7cb22e50d72ae183641e1e16bfd666f15f9c5dbfc9d600658ad1110fd
  static const String _defaultUsernameHash = String.fromEnvironment(
    'ADMIN_USERNAME_HASH',
    defaultValue:
        '642ed0bca90e038e74de2e45265ead2b5b700642e8a7e9ea02755792c88d73ee',
  );

  static const String _defaultPasswordHash = String.fromEnvironment(
    'ADMIN_PASSWORD_HASH',
    defaultValue:
        '38d5b2f7cb22e50d72ae183641e1e16bfd666f15f9c5dbfc9d600658ad1110fd',
  );

  final String expectedUsernameHash;
  final String expectedPasswordHash;

  @override
  Future<AuthSession> authenticate({
    required String username,
    required String password,
  }) async {
    // Artificial 350ms delay to mitigate timing attacks and simulate network latency
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final String computedUserHash =
        sha256.convert(utf8.encode(username.trim())).toString().toLowerCase();
    final String computedPassHash =
        sha256.convert(utf8.encode(password.trim())).toString().toLowerCase();

    final bool isUserMatch =
        computedUserHash == expectedUsernameHash.toLowerCase();
    final bool isPassMatch =
        computedPassHash == expectedPasswordHash.toLowerCase();

    if (!isUserMatch || !isPassMatch) {
      throw const AuthFailure('Invalid username or password.');
    }

    final String sessionToken = _generateSecureOpaqueToken();
    final DateTime now = DateTime.now();

    return AuthSession(
      token: sessionToken,
      username: username.trim(),
      issuedAt: now,
      expiresAt: now.add(const Duration(hours: 8)),
    );
  }

  String _generateSecureOpaqueToken() {
    final Random random = Random.secure();
    final List<int> values = List<int>.generate(32, (int i) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }
}
