import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_profile_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockProfileContentRepository mockProfileRepo;

  setUp(() {
    registerTestFallbacks();
    mockProfileRepo = MockProfileContentRepository();
  });

  group('AdminProfileViewModel Tests', () {
    test('Initial loading populates draft and version history', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => Success<List<ProfileVersion>>(<ProfileVersion>[
                ProfileVersion(
                  versionId: 'v1_initial',
                  publishedAt: DateTime(2025),
                  draft: ProfileDraft.initialDefault,
                ),
              ]));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );

      await pumpEventQueue();

      expect(vm.viewState, ViewState.success);
      expect(vm.draft.name, ProfileDraft.initialDefault.name);
      expect(vm.versions.length, 1);
      expect(vm.errorMessage, isEmpty);
    });

    test('updateDraft modifies draft and sanitizes XSS inputs', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      vm.updateDraft(
        name: '<b>Eliott</b><script>alert("xss")</script>',
        role: 'Senior <style>body{}</style>Developer',
      );

      expect(vm.draft.name, 'Eliott');
      expect(vm.draft.role, 'Senior Developer');
    });

    test('sanitizeText strips dangerous tags and scripts', () {
      expect(
        AdminProfileViewModel.sanitizeText('<script>alert("hack")</script>Hello World'),
        'Hello World',
      );
      expect(
        AdminProfileViewModel.sanitizeText('<a href="javascript:alert(1)">Click</a>'),
        'Click',
      );
      expect(
        AdminProfileViewModel.sanitizeText('&lt;div&gt;Clean&lt;/div&gt;'),
        'Clean',
      );
    });

    test('parseResumeTextToDraft extracts name, role, and detected skills', () {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );

      const String resumeText = '''
Jane Doe
Senior UI/UX Designer and Frontend Engineer
Summary
Passionate about building scalable Flutter applications and Figma design systems.
Strong focus on user experience and accessibility across web platforms.
Skills
Flutter, Dart, Figma, TypeScript, React, Next.js, Tailwind CSS, Git, Firebase
''';

      final ProfileDraft parsed = vm.parseResumeTextToDraft(resumeText);

      expect(parsed.name, 'Jane Doe');
      expect(parsed.role, 'Senior UI/UX Designer and Frontend Engineer');
      expect(parsed.bioPara1, contains('Passionate about building scalable Flutter applications'));
      expect(parsed.tools, contains('Flutter'));
      expect(parsed.tools, contains('Figma'));
      expect(parsed.tools, contains('Tailwind CSS'));
      expect(parsed.tools, contains('Dart'));
    });

    test('publish saves draft to repository and reloads versions', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));
      when(() => mockProfileRepo.publishProfile(any()))
          .thenAnswer((_) async => const Success<void>(null));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      vm.updateDraft(name: 'Updated Name');

      final bool success = await vm.publish();

      expect(success, isTrue);
      expect(vm.successMessage, contains('Profile updated and published successfully'));
      verify(() => mockProfileRepo.publishProfile(any())).called(1);
    });

    test('revertToVersion reverts draft to chosen version', () async {
      final ProfileDraft oldDraft = ProfileDraft.initialDefault.copyWith(
        name: 'Old Version Name',
      );
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));
      when(() => mockProfileRepo.revertToVersion('v1_initial'))
          .thenAnswer((_) async => Success<ProfileDraft>(oldDraft));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      final bool success = await vm.revertToVersion('v1_initial');

      expect(success, isTrue);
      expect(vm.draft.name, 'Old Version Name');
      expect(vm.successMessage, contains('Reverted successfully to version v1_initial'));
    });

    test('Handles repository error when publishing fails', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));
      when(() => mockProfileRepo.publishProfile(any()))
          .thenAnswer((_) async =>
          const FailureResult<void>(ServerFailure('Permission denied')));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      final bool success = await vm.publish();

      expect(success, isFalse);
      expect(vm.errorMessage, 'Permission denied');
    });

    test('updateDraft and updateAvatarUrl modify avatarUrl with sanitization', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      expect(vm.hasCustomAvatar, isFalse);

      vm.updateAvatarUrl('https://example.com/photo.png<script>alert(1)</script>');
      expect(vm.draft.avatarUrl, 'https://example.com/photo.png');
      expect(vm.hasCustomAvatar, isTrue);

      vm.updateDraft(avatarUrl: 'https://images.unsplash.com/custom-photo.jpg');
      expect(vm.draft.avatarUrl, 'https://images.unsplash.com/custom-photo.jpg');
      expect(vm.hasCustomAvatar, isTrue);
    });

    test('resetAvatar restores default portrait avatarUrl', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      vm.updateAvatarUrl('https://example.com/custom-user.png');
      expect(vm.hasCustomAvatar, isTrue);

      vm.resetAvatar();
      expect(vm.draft.avatarUrl, ProfileDraft.defaultAvatarUrl);
      expect(vm.hasCustomAvatar, isFalse);
      expect(vm.successMessage, contains('reset to default'));
    });

    test('parseResumeTextToDraft preserves existing avatarUrl', () async {
      when(() => mockProfileRepo.getActiveProfile())
          .thenAnswer((_) async => const Success<ProfileDraft>(ProfileDraft.initialDefault));
      when(() => mockProfileRepo.getVersionHistory())
          .thenAnswer((_) async => const Success<List<ProfileVersion>>(<ProfileVersion>[]));

      final AdminProfileViewModel vm = AdminProfileViewModel(
        profileRepository: mockProfileRepo,
      );
      await pumpEventQueue();

      vm.updateAvatarUrl('https://custom.cdn/my-avatar.png');

      final ProfileDraft parsed = vm.parseResumeTextToDraft('New Name\nLead Architect');
      expect(parsed.avatarUrl, 'https://custom.cdn/my-avatar.png');
    });
  });
}
