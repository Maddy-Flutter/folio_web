import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/flavor_config.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/core/theme/app_theme.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/di/app_providers.dart';
import 'package:follio/presentation/admin/views/admin_profile_view.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockThemeRepository mockThemeRepo;
  late MockProfileContentRepository mockProfileRepo;

  setUp(() {
    registerTestFallbacks();
    if (!FlavorConfig.isInitialized) {
      FlavorConfig.initialize(flavor: Flavor.admin);
    }
    mockAuthRepo = MockAuthRepository();
    mockThemeRepo = MockThemeRepository();
    mockProfileRepo = MockProfileContentRepository();

    when(() => mockThemeRepo.getSavedThemeMode())
        .thenAnswer((_) async => ThemeMode.dark);
    when(() => mockThemeRepo.saveThemeMode(any()))
        .thenAnswer((_) async {});
  });

  Widget buildProfileTestApp({ProfileDraft? initialDraft}) {
    final ProfileDraft draft = initialDraft ?? ProfileDraft.initialDefault;

    when(() => mockProfileRepo.getActiveProfile())
        .thenAnswer((_) async => Success<ProfileDraft>(draft));
    when(() => mockProfileRepo.getVersionHistory())
        .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));

    return AppProviders(
      flavor: Flavor.admin,
      authRepository: mockAuthRepo,
      themeRepository: mockThemeRepo,
      profileContentRepository: mockProfileRepo,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const Scaffold(body: AdminProfileView()),
      ),
    );
  }

  group('AdminProfileView Widget Tests', () {
    testWidgets('Renders header, resume upload zone, and avatar controls',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildProfileTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Portfolio Content'), findsOneWidget);
      expect(find.text('Folio Profile Update'), findsOneWidget);
      expect(find.text('Upload Resume Document'), findsOneWidget);
      expect(find.text('Profile Avatar'), findsOneWidget);
      expect(find.text('Upload Image'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('Shows Custom badge and Reset to Default button when custom avatar is present',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const ProfileDraft customDraft = ProfileDraft(
        name: 'Alex Rivera',
        greeting: "Hi, I'm ",
        role: 'Lead UI/UX Architect',
        bioPara1: 'Bio paragraph 1',
        bioPara2: 'Bio paragraph 2',
        tools: <String>['Flutter', 'Figma'],
        avatarUrl: 'https://images.unsplash.com/photo-custom?w=800',
      );

      await tester.pumpWidget(buildProfileTestApp(initialDraft: customDraft));
      await tester.pumpAndSettle();

      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Reset to Default'), findsOneWidget);

      // Tap Reset to Default
      await tester.tap(find.text('Reset to Default'));
      await tester.pumpAndSettle();

      // Custom badge and Reset button disappear after resetting
      expect(find.text('Custom'), findsNothing);
      expect(find.text('Reset to Default'), findsNothing);
    });

    testWidgets('Entering image URL and clicking Apply updates avatar draft',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildProfileTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Custom'), findsNothing);

      final Finder urlField = find.widgetWithText(TextField, 'Or paste image URL (https://...)');
      expect(urlField, findsOneWidget);

      await tester.enterText(urlField, 'https://cdn.example.com/new-avatar.png');
      await tester.tap(find.byTooltip('Apply URL'));
      await tester.pumpAndSettle();

      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Reset to Default'), findsOneWidget);
    });
  });
}
