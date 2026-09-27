import 'package:flutter/material.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/di/admin_providers.dart';
import 'package:follio/di/core_providers.dart';
import 'package:follio/di/user_providers.dart';
import 'package:follio/domain/repositories/analytics_repository.dart';
import 'package:follio/domain/repositories/auth_repository.dart';
import 'package:follio/domain/repositories/contact_repository.dart';
import 'package:follio/domain/repositories/messages_repository.dart';
import 'package:follio/domain/repositories/portfolio_repository.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';
import 'package:follio/domain/repositories/theme_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.child,
    this.flavor,
    this.themeRepository,
    this.authStorage,
    // User flavor dependencies / mocks
    this.portfolioRepository,
    this.contactRepository,
    this.profileContentRepository,
    // Admin flavor dependencies / mocks
    this.authRepository,
    this.messagesRepository,
    this.analyticsRepository,
  });

  final Widget child;
  final Flavor? flavor;
  final ThemeRepository? themeRepository;
  final AuthStorage? authStorage;
  final PortfolioRepository? portfolioRepository;
  final ContactRepository? contactRepository;
  final ProfileContentRepository? profileContentRepository;
  final AuthRepository? authRepository;
  final MessagesRepository? messagesRepository;
  final AnalyticsRepository? analyticsRepository;

  @override
  Widget build(BuildContext context) {
    final Flavor currentFlavor = flavor ??
        (FlavorConfig.isInitialized ? FlavorConfig.instance.flavor : Flavor.user);

    final List<SingleChildWidget> core = buildCoreProviders(
      themeRepository: themeRepository,
      authStorage: authStorage,
    );

    final List<SingleChildWidget> flavorSpecific = switch (currentFlavor) {
      Flavor.user => buildUserProviders(
          portfolioRepository: portfolioRepository,
          contactRepository: contactRepository,
          profileContentRepository: profileContentRepository,
          analyticsRepository: analyticsRepository,
          messagesRepository: messagesRepository,
        ),
      Flavor.admin => buildAdminProviders(
          authRepository: authRepository,
          messagesRepository: messagesRepository,
          analyticsRepository: analyticsRepository,
          profileContentRepository: profileContentRepository,
        ),
    };

    return MultiProvider(
      providers: <SingleChildWidget>[
        ...core,
        ...flavorSpecific,
      ],
      child: child,
    );
  }
}
