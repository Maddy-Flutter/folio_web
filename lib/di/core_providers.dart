import 'package:flutter/material.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/auth/auth_storage_factory.dart';
import 'package:follio/data/datasources/preferences_local_data_source.dart';
import 'package:follio/data/repositories/theme_repository_impl.dart';
import 'package:follio/domain/repositories/theme_repository.dart';
import 'package:follio/presentation/viewmodels/theme_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> buildCoreProviders({
  ThemeRepository? themeRepository,
  AuthStorage? authStorage,
}) {
  return <SingleChildWidget>[
    Provider<PreferencesLocalDataSource>(
      create: (_) => PreferencesLocalDataSourceImpl(),
    ),
    Provider<AuthStorage>(
      create: (_) => authStorage ?? AuthStorageFactory.create(),
    ),
    ProxyProvider<PreferencesLocalDataSource, ThemeRepository>(
      update: (_, PreferencesLocalDataSource prefs, _) =>
          themeRepository ?? ThemeRepositoryImpl(preferencesDataSource: prefs),
    ),
    ChangeNotifierProxyProvider<ThemeRepository, ThemeViewModel>(
      create: (BuildContext ctx) =>
          ThemeViewModel(themeRepository: ctx.read<ThemeRepository>()),
      update: (_, ThemeRepository repo, ThemeViewModel? prev) =>
          prev ?? ThemeViewModel(themeRepository: repo),
    ),
  ];
}
