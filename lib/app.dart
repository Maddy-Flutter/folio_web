import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_constants.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/router/app_router.dart';
import 'package:follio/core/theme/app_theme.dart';
import 'package:follio/presentation/viewmodels/theme_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({
    super.key,
    this.router,
  });

  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = context.select<ThemeViewModel, ThemeMode>(
      (ThemeViewModel vm) => vm.themeMode,
    );

    final String appTitle = FlavorConfig.isInitialized
        ? FlavorConfig.instance.appTitle
        : AppConstants.appTitle;

    return MaterialApp.router(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router ?? AppRouter.router,
    );
  }
}
