enum Flavor {
  user,
  admin,
}

final class FlavorConfig {
  FlavorConfig._({
    required this.flavor,
    required this.appTitle,
    required this.initialRoute,
  });

  final Flavor flavor;
  final String appTitle;
  final String initialRoute;

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError(
        'FlavorConfig has not been initialized. Call FlavorConfig.initialize() before accessing.',
      );
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static void initialize({
    required Flavor flavor,
    String? appTitle,
    String? initialRoute,
  }) {
    final String resolvedTitle = appTitle ??
        switch (flavor) {
          Flavor.user => 'Eliott — Freelance UI/UX Designer & Frontend Developer',
          Flavor.admin => 'Folio Admin Console',
        };

    final String resolvedInitialRoute = initialRoute ??
        switch (flavor) {
          Flavor.user => '/',
          Flavor.admin => '/admin/login',
        };

    _instance = FlavorConfig._(
      flavor: flavor,
      appTitle: resolvedTitle,
      initialRoute: resolvedInitialRoute,
    );
  }

  bool get isUser => flavor == Flavor.user;
  bool get isAdmin => flavor == Flavor.admin;
}
