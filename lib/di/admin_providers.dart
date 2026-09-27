import 'package:flutter/material.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/data/datasources/admin_auth_data_source.dart';
import 'package:follio/data/datasources/admin_firestore_data_source.dart';
import 'package:follio/data/repositories/analytics_repository_impl.dart';
import 'package:follio/data/repositories/auth_repository_impl.dart';
import 'package:follio/data/repositories/messages_repository_impl.dart';
import 'package:follio/data/repositories/profile_content_repository_impl.dart';
import 'package:follio/domain/repositories/analytics_repository.dart';
import 'package:follio/domain/repositories/auth_repository.dart';
import 'package:follio/domain/repositories/messages_repository.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';
import 'package:follio/presentation/admin/viewmodels/admin_auth_viewmodel.dart';
import 'package:follio/presentation/admin/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:follio/presentation/admin/viewmodels/admin_messages_viewmodel.dart';
import 'package:follio/presentation/admin/viewmodels/admin_profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> buildAdminProviders({
  AuthRepository? authRepository,
  MessagesRepository? messagesRepository,
  AnalyticsRepository? analyticsRepository,
  ProfileContentRepository? profileContentRepository,
}) {
  return <SingleChildWidget>[
    Provider<AdminAuthDataSource>(
      create: (_) => const AdminAuthDataSourceImpl(),
    ),
    Provider<AdminFirestoreDataSource>(
      create: (_) => AdminFirestoreDataSourceImpl.instance,
    ),
    ProxyProvider2<AdminAuthDataSource, AuthStorage, AuthRepository>(
      update: (_, AdminAuthDataSource ds, AuthStorage storage, _) =>
          authRepository ??
          AuthRepositoryImpl(
            authDataSource: ds,
            authStorage: storage,
          ),
    ),
    ProxyProvider<AdminFirestoreDataSource, MessagesRepository>(
      update: (_, AdminFirestoreDataSource ds, _) =>
          messagesRepository ?? MessagesRepositoryImpl(dataSource: ds),
    ),
    ProxyProvider<AdminFirestoreDataSource, AnalyticsRepository>(
      update: (_, AdminFirestoreDataSource ds, _) =>
          analyticsRepository ?? AnalyticsRepositoryImpl(dataSource: ds),
    ),
    ProxyProvider<AdminFirestoreDataSource, ProfileContentRepository>(
      update: (_, AdminFirestoreDataSource ds, _) =>
          profileContentRepository ?? ProfileContentRepositoryImpl(dataSource: ds),
    ),

    // ViewModels
    ChangeNotifierProxyProvider<AuthRepository, AdminAuthViewModel>(
      create: (BuildContext ctx) =>
          AdminAuthViewModel(authRepository: ctx.read<AuthRepository>()),
      update: (_, AuthRepository repo, AdminAuthViewModel? prev) =>
          prev ?? AdminAuthViewModel(authRepository: repo),
    ),
    ChangeNotifierProxyProvider2<AnalyticsRepository, MessagesRepository, AdminDashboardViewModel>(
      create: (BuildContext ctx) => AdminDashboardViewModel(
        analyticsRepository: ctx.read<AnalyticsRepository>(),
        messagesRepository: ctx.read<MessagesRepository>(),
      ),
      update: (_, AnalyticsRepository analyticsRepo, MessagesRepository msgRepo, AdminDashboardViewModel? prev) =>
          prev ??
          AdminDashboardViewModel(
            analyticsRepository: analyticsRepo,
            messagesRepository: msgRepo,
          ),
    ),
    ChangeNotifierProxyProvider<MessagesRepository, AdminMessagesViewModel>(
      create: (BuildContext ctx) =>
          AdminMessagesViewModel(messagesRepository: ctx.read<MessagesRepository>()),
      update: (_, MessagesRepository repo, AdminMessagesViewModel? prev) =>
          prev ?? AdminMessagesViewModel(messagesRepository: repo),
    ),
    ChangeNotifierProxyProvider<ProfileContentRepository, AdminProfileViewModel>(
      create: (BuildContext ctx) =>
          AdminProfileViewModel(profileRepository: ctx.read<ProfileContentRepository>()),
      update: (_, ProfileContentRepository repo, AdminProfileViewModel? prev) =>
          prev ?? AdminProfileViewModel(profileRepository: repo),
    ),
  ];
}
