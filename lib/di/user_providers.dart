import 'package:flutter/material.dart';
import 'package:follio/core/services/analytics_service.dart';
import 'package:follio/data/datasources/admin_firestore_data_source.dart';
import 'package:follio/data/datasources/contact_remote_data_source.dart';
import 'package:follio/data/datasources/portfolio_local_data_source.dart';
import 'package:follio/data/datasources/preferences_local_data_source.dart';
import 'package:follio/data/repositories/analytics_repository_impl.dart';
import 'package:follio/data/repositories/contact_repository_impl.dart';
import 'package:follio/data/repositories/messages_repository_impl.dart';
import 'package:follio/data/repositories/portfolio_repository_impl.dart';
import 'package:follio/data/repositories/profile_content_repository_impl.dart';
import 'package:follio/domain/repositories/analytics_repository.dart';
import 'package:follio/domain/repositories/contact_repository.dart';
import 'package:follio/domain/repositories/messages_repository.dart';
import 'package:follio/domain/repositories/portfolio_repository.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';
import 'package:follio/presentation/viewmodels/contact_viewmodel.dart';
import 'package:follio/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> buildUserProviders({
  PortfolioRepository? portfolioRepository,
  ContactRepository? contactRepository,
  ProfileContentRepository? profileContentRepository,
  AnalyticsRepository? analyticsRepository,
  MessagesRepository? messagesRepository,
}) {
  return <SingleChildWidget>[
    Provider<PortfolioLocalDataSource>(
      create: (_) => const PortfolioLocalDataSourceImpl(),
    ),
    Provider<ContactRemoteDataSource>(
      create: (_) => ContactRemoteDataSourceImpl(),
    ),
    Provider<AdminFirestoreDataSource>(
      create: (_) => AdminFirestoreDataSourceImpl.instance,
    ),
    ProxyProvider<PortfolioLocalDataSource, PortfolioRepository>(
      update: (_, PortfolioLocalDataSource ds, _) =>
          portfolioRepository ?? PortfolioRepositoryImpl(localDataSource: ds),
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
    ProxyProvider<AnalyticsRepository, AnalyticsService>(
      update: (_, AnalyticsRepository repo, _) =>
          AnalyticsService(analyticsRepository: repo),
    ),
    ProxyProvider3<ContactRemoteDataSource, PreferencesLocalDataSource, MessagesRepository, ContactRepository>(
      update: (_, ContactRemoteDataSource remote, PreferencesLocalDataSource prefs, MessagesRepository messages, _) =>
          contactRepository ??
          ContactRepositoryImpl(
            remoteDataSource: remote,
            preferencesDataSource: prefs,
            messagesRepository: messages,
          ),
    ),
    ChangeNotifierProvider<NavigationViewModel>(
      create: (_) => NavigationViewModel(),
    ),
    ChangeNotifierProxyProvider2<PortfolioRepository, ProfileContentRepository, PortfolioViewModel>(
      create: (BuildContext ctx) => PortfolioViewModel(
        portfolioRepository: ctx.read<PortfolioRepository>(),
        profileContentRepository: ctx.read<ProfileContentRepository>(),
      ),
      update: (_, PortfolioRepository repo, ProfileContentRepository profileRepo, PortfolioViewModel? prev) =>
          prev ??
          PortfolioViewModel(
            portfolioRepository: repo,
            profileContentRepository: profileRepo,
          ),
    ),
    ChangeNotifierProxyProvider<ContactRepository, ContactViewModel>(
      create: (BuildContext ctx) =>
          ContactViewModel(contactRepository: ctx.read<ContactRepository>()),
      update: (_, ContactRepository repo, ContactViewModel? prev) =>
          prev ?? ContactViewModel(contactRepository: repo),
    ),
  ];
}
