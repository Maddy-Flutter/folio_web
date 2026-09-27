import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/contact_submission_dto.dart';
import 'package:follio/data/repositories/contact_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockContactRemoteDataSource mockRemoteDataSource;
  late MockPreferencesLocalDataSource mockPreferencesDataSource;
  late ContactRepositoryImpl repository;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockRemoteDataSource = MockContactRemoteDataSource();
    mockPreferencesDataSource = MockPreferencesLocalDataSource();
    repository = ContactRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      preferencesDataSource: mockPreferencesDataSource,
    );

    when(() => mockPreferencesDataSource.getLastSubmitTimestamp())
        .thenAnswer((_) async => null);
    when(() => mockPreferencesDataSource.setLastSubmitTimestamp(any()))
        .thenAnswer((_) async {});
  });

  group('ContactRepositoryImpl Tests', () {
    test('Honeypot returns Success without sending remote call', () async {
      const ContactSubmissionDto botSubmission = ContactSubmissionDto(
        name: 'Bot User',
        email: 'bot@example.com',
        message: 'Spam bot automated message.',
        honeypot: 'filled_by_bot',
      );

      final Result<void> result = await repository.submitContactForm(botSubmission);

      expect(result.isSuccess, isTrue);
      verifyNever(() => mockRemoteDataSource.sendInquiry(any()));
    });

    test('Fails validation if inputs are invalid', () async {
      const ContactSubmissionDto invalidSubmission = ContactSubmissionDto(
        name: 'A',
        email: 'invalid',
        message: 'short',
      );

      final Result<void> result = await repository.submitContactForm(invalidSubmission);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyNever(() => mockRemoteDataSource.sendInquiry(any()));
    });

    test('Rejects submission if rate limit is active (< 60s ago)', () async {
      final int recentMs = DateTime.now().millisecondsSinceEpoch - 20000; // 20s ago
      when(() => mockPreferencesDataSource.getLastSubmitTimestamp())
          .thenAnswer((_) async => recentMs);

      const ContactSubmissionDto validSubmission = ContactSubmissionDto(
        name: 'Jane Smith',
        email: 'jane@company.com',
        message: 'Legitimate detailed message for collaboration.',
      );

      final Result<void> result = await repository.submitContactForm(validSubmission);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<RateLimitFailure>());
      verifyNever(() => mockRemoteDataSource.sendInquiry(any()));
    });

    test('Successfully submits and records timestamp', () async {
      when(() => mockRemoteDataSource.sendInquiry(any()))
          .thenAnswer((_) async {});

      const ContactSubmissionDto validSubmission = ContactSubmissionDto(
        name: 'Jane Smith',
        email: 'jane@company.com',
        message: 'Legitimate detailed message for collaboration.',
      );

      final Result<void> result = await repository.submitContactForm(validSubmission);

      expect(result.isSuccess, isTrue);
      verify(() => mockRemoteDataSource.sendInquiry(validSubmission)).called(1);
      verify(() => mockPreferencesDataSource.setLastSubmitTimestamp(any())).called(1);
    });

    test('Catches remote network failure gracefully', () async {
      when(() => mockRemoteDataSource.sendInquiry(any()))
          .thenThrow(const NetworkFailure('No Internet'));

      const ContactSubmissionDto validSubmission = ContactSubmissionDto(
        name: 'Jane Smith',
        email: 'jane@company.com',
        message: 'Legitimate detailed message for collaboration.',
      );

      final Result<void> result = await repository.submitContactForm(validSubmission);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });
}
