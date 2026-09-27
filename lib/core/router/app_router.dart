import 'package:flutter/material.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/auth/auth_storage_factory.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/router/auth_guard.dart';
import 'package:follio/presentation/admin/views/admin_dashboard_view.dart';
import 'package:follio/presentation/admin/views/admin_login_view.dart';
import 'package:follio/presentation/admin/views/admin_messages_view.dart';
import 'package:follio/presentation/admin/views/admin_profile_view.dart';
import 'package:follio/presentation/admin/views/admin_shell.dart';
import 'package:follio/presentation/views/blog/blog_view.dart';
import 'package:follio/presentation/views/blog_article/blog_article_view.dart';
import 'package:follio/presentation/views/case_study/case_study_view.dart';
import 'package:follio/presentation/views/home/home_view.dart';
import 'package:follio/presentation/views/not_found/not_found_view.dart';
import 'package:follio/presentation/views/projects/projects_view.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter? _routerInstance;

  static GoRouter get router {
    return _routerInstance ??= createRouter();
  }

  static void resetForTesting() {
    _routerInstance = null;
  }

  static GoRouter createRouter({
    AuthStorage? authStorage,
    String? initialLocation,
  }) {
    final AuthStorage storage = authStorage ?? AuthStorageFactory.create();
    final String initial = initialLocation ??
        (FlavorConfig.isInitialized
            ? FlavorConfig.instance.initialRoute
            : '/');

    return GoRouter(
      initialLocation: initial,
      redirect: (BuildContext context, GoRouterState state) =>
          AuthGuard.redirect(context: context, state: state, authStorage: storage),
      errorBuilder: (BuildContext context, GoRouterState state) => const NotFoundView(),
      routes: <RouteBase>[
        // Public Portfolio Routes (User Flavor)
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) => Title(
            title: 'Eliott — Freelance UI/UX Designer & Frontend Developer',
            color: const Color(0xFFFF6B2B),
            child: const HomeView(),
          ),
        ),
        GoRoute(
          path: '/projects',
          name: 'projects',
          builder: (BuildContext context, GoRouterState state) => Title(
            title: 'Projects — Eliott',
            color: const Color(0xFFFF6B2B),
            child: const ProjectsView(),
          ),
        ),
        GoRoute(
          path: '/case-study/:slug',
          name: 'case-study',
          builder: (BuildContext context, GoRouterState state) {
            final String slug = state.pathParameters['slug'] ?? '';
            return Title(
              title: 'Case Study · Eliott',
              color: const Color(0xFFFF6B2B),
              child: CaseStudyView(slug: slug),
            );
          },
        ),
        GoRoute(
          path: '/blog',
          name: 'blog',
          builder: (BuildContext context, GoRouterState state) => Title(
            title: 'The Blog — Eliott',
            color: const Color(0xFFFF6B2B),
            child: const BlogView(),
          ),
        ),
        GoRoute(
          path: '/blog/:slug',
          name: 'blog-article',
          builder: (BuildContext context, GoRouterState state) {
            final String slug = state.pathParameters['slug'] ?? '';
            return Title(
              title: 'Article · Eliott',
              color: const Color(0xFFFF6B2B),
              child: BlogArticleView(slug: slug),
            );
          },
        ),

        // Admin Auth Route (Admin Flavor)
        GoRoute(
          path: '/admin/login',
          name: 'admin-login',
          builder: (BuildContext context, GoRouterState state) => Title(
            title: 'Folio Admin — Login',
            color: const Color(0xFFFF6B2B),
            child: const AdminLoginView(),
          ),
        ),

        // Admin Console Shell Routes (Protected by AuthGuard)
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return AdminShell(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/admin/dashboard',
              name: 'admin-dashboard',
              builder: (BuildContext context, GoRouterState state) => Title(
                title: 'Folio Admin — Dashboard',
                color: const Color(0xFFFF6B2B),
                child: const AdminDashboardView(),
              ),
            ),
            GoRoute(
              path: '/admin/messages',
              name: 'admin-messages',
              builder: (BuildContext context, GoRouterState state) => Title(
                title: 'Folio Admin — Messages',
                color: const Color(0xFFFF6B2B),
                child: const AdminMessagesView(),
              ),
            ),
            GoRoute(
              path: '/admin/profile-update',
              name: 'admin-profile-update',
              builder: (BuildContext context, GoRouterState state) => Title(
                title: 'Folio Admin — Profile Update',
                color: const Color(0xFFFF6B2B),
                child: const AdminProfileView(),
              ),
            ),
          ],
        ),

        // 404 Not Found Route
        GoRoute(
          path: '/404',
          name: 'not-found',
          builder: (BuildContext context, GoRouterState state) => const NotFoundView(),
        ),
      ],
    );
  }
}
