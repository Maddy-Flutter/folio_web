import 'package:flutter/material.dart';
import 'package:follio/app.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/router/app_router.dart';
import 'package:follio/di/app_providers.dart';

void bootstrap(Flavor flavor) {
  WidgetsFlutterBinding.ensureInitialized();

  if (!FlavorConfig.isInitialized) {
    FlavorConfig.initialize(flavor: flavor);
  }

  // Reset router cache to ensure initialRoute matches flavor
  AppRouter.resetForTesting();

  // Production global error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline_rounded, size: 48.0, color: Color(0xFFEF4444)),
              const SizedBox(height: 16.0),
              const Text(
                'Something unexpected occurred',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                details.exceptionAsString(),
                style: const TextStyle(fontSize: 13.0, color: Color(0xFF71717A)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(
    AppProviders(
      flavor: flavor,
      child: const PortfolioApp(),
    ),
  );
}
