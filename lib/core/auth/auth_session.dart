import 'dart:convert';

final class AuthSession {
  const AuthSession({
    required this.token,
    required this.username,
    required this.issuedAt,
    required this.expiresAt,
  });

  final String token;
  final String username;
  final DateTime issuedAt;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => token.isNotEmpty && !isExpired;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'username': username,
      'issuedAt': issuedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token'] as String? ?? '',
      username: json['username'] as String? ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String toCookieValue() {
    return base64Url.encode(utf8.encode(jsonEncode(toJson())));
  }

  static AuthSession? fromCookieValue(String raw) {
    try {
      final String decoded = utf8.decode(base64Url.decode(raw));
      final Map<String, dynamic> map = jsonDecode(decoded) as Map<String, dynamic>;
      return AuthSession.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
