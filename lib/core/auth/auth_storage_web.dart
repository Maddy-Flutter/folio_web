import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:web/web.dart' as web;

/// Web implementation of [AuthStorage] using client-managed cookies.
///
/// SECURITY NOTE & LIMITATION:
/// A true "HttpOnly" cookie can ONLY be set by a web server via the `Set-Cookie` HTTP
/// response header (e.g. from an authentication microservice, Firebase Auth session cookie,
/// or Cloud Function). Client-side JavaScript/Dart code running in the browser CANNOT set
/// the `HttpOnly` attribute on `document.cookie` because browser security models restrict
/// HttpOnly cookies from being read or written by client scripts to prevent XSS exfiltration.
///
/// As a robust client-side mitigation, this class:
/// 1. Writes to `document.cookie` with `Secure; SameSite=Strict; Path=/` and an explicit `max-age`
///    matching session lifetime (default 8 hours / 28800 seconds).
/// 2. Treats the parsed cookie as the single source of truth for session status, refreshing
///    its timestamp and validity on admin operations.
/// 3. In a production environment with a backend, replace this implementation by calling
///    your auth server endpoint (e.g. `POST /api/auth/session`) which mints a genuine
///    `HttpOnly; Secure; SameSite=Strict` cookie directly in the response headers.
final class WebCookieAuthStorage implements AuthStorage {
  static const String _cookieKey = 'folio_admin_session';

  @override
  Future<void> saveSession(AuthSession session) async {
    final String val = session.toCookieValue();
    final int maxAgeSeconds = session.expiresAt.difference(DateTime.now()).inSeconds;
    final int safeMaxAge = maxAgeSeconds > 0 ? maxAgeSeconds : 28800; // 8 hours default

    web.document.cookie =
        '$_cookieKey=$val; max-age=$safeMaxAge; path=/; samesite=strict; secure';
  }

  @override
  Future<AuthSession?> getSession() async {
    final String cookieString = web.document.cookie;
    if (cookieString.isEmpty) return null;

    final List<String> cookies = cookieString.split(';');
    for (final String cookie in cookies) {
      final String trimmed = cookie.trim();
      if (trimmed.startsWith('$_cookieKey=')) {
        final String rawValue = trimmed.substring('$_cookieKey='.length);
        final AuthSession? session = AuthSession.fromCookieValue(rawValue);
        if (session != null && !session.isExpired) {
          return session;
        } else {
          await clearSession();
          return null;
        }
      }
    }
    return null;
  }

  @override
  Future<void> clearSession() async {
    web.document.cookie =
        '$_cookieKey=; max-age=0; path=/; samesite=strict; secure';
  }
}

AuthStorage getPlatformAuthStorage() => WebCookieAuthStorage();
