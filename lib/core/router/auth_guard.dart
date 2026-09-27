import 'package:flutter/widgets.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:go_router/go_router.dart';

abstract final class AuthGuard {
  static Future<String?> redirect({
    required BuildContext context,
    required GoRouterState state,
    required AuthStorage authStorage,
  }) async {
    final FlavorConfig config = FlavorConfig.instance;
    final String path = state.uri.path;

    // 1. Cross-flavor guard: User flavor must NEVER access admin routes
    if (config.isUser) {
      if (path.startsWith('/admin')) {
        return '/404';
      }
      return null;
    }

    // 2. Cross-flavor guard: Admin flavor must NEVER access public portfolio routes
    if (config.isAdmin) {
      if (!path.startsWith('/admin')) {
        return '/admin/login';
      }

      // 3. Admin session validation
      final AuthSession? session = await authStorage.getSession();
      final bool isAuthenticated = session != null && session.isValid;

      final bool isLoggingIn = path == '/admin/login';

      if (!isAuthenticated) {
        return isLoggingIn ? null : '/admin/login';
      }

      // If already authenticated and visiting /admin or /admin/login, redirect to dashboard
      if (isLoggingIn || path == '/admin') {
        return '/admin/dashboard';
      }

      return null;
    }

    return null;
  }
}
