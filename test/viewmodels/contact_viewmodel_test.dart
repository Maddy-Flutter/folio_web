import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/presentation/viewmodels/contact_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockContactRepository mockContactRepo;
  late ContactViewModel viewModel;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockContactRepo = MockContactRepository();
    viewModel = ContactViewModel(contactRepository: mockContactRepo);
  });

  group('ContactViewModel Validation', () {
    test('Initial state is idle with no errors', () {
      expect(viewModel.submitState, ViewState.idle);
      expect(viewModel.nameError, isNull);
      expect(viewModel.emailError, isNull);
      expect(viewModel.subjectError, isNull);
      expect(viewModel.messageError, isNull);
    });

    test('Validates name length (2 to 60 characters)', () {
      viewModel.setName('J');
      viewModel.onNameBlur();
      expect(viewModel.nameError, AppStrings.valNameRequired);

      viewModel.setName('Jane Doe');
      expect(viewModel.nameError, isNull);

      viewModel.setName('A' * 61);
      expect(viewModel.nameError, AppStrings.valNameRequired);
    });

    test('Validates email format via RFC regex', () {
      viewModel.setEmail('invalid-email');
      viewModel.onEmailBlur();
      expect(viewModel.emailError, AppStrings.valEmailInvalid);

      viewModel.setEmail('test@');
      expect(viewModel.emailError, AppStrings.valEmailInvalid);

      viewModel.setEmail('jane@example.com');
      expect(viewModel.emailError, isNull);
    });

    test('Validates subject optional but max 120 characters', () {
      viewModel.setSubject('');
      viewModel.onSubjectBlur();
      expect(viewModel.subjectError, isNull);

      viewModel.setSubject('A' * 121);
      expect(viewModel.subjectError, AppStrings.valSubjectTooLong);

      viewModel.setSubject('Project Redesign');
      expect(viewModel.subjectError, isNull);
    });

    test('Validates message length (10 to 2000 characters)', () {
      viewModel.setMessage('Too short');
      viewModel.onMessageBlur();
      expect(viewModel.messageError, AppStrings.valMessageRequired);

      viewModel.setMessage('This is a sufficiently detailed inquiry message.');
      expect(viewModel.messageError, isNull);

      viewModel.setMessage('A' * 2001);
      expect(viewModel.messageError, AppStrings.valMessageRequired);
    });
  });

  group('ContactViewModel Submission Branches', () {
    test('Fails validation and does not submit if fields are invalid', () async {
      viewModel.setName('J');
      final bool result = await viewModel.submit();

      expect(result, isFalse);
      expect(viewModel.submitState, ViewState.idle);
      verifyNever(() => mockContactRepo.submitContactForm(any()));
    });

    test('Submits successfully when inputs are valid', () async {
      viewModel.setName('Jane Smith');
      viewModel.setEmail('jane@company.com');
      viewModel.setSubject('Product Design Inquiry');
      viewModel.setMessage('I would love to discuss an upcoming redesign project.');

      when(() => mockContactRepo.submitContactForm(any()))
          .thenAnswer((_) async => const Success<void>(null));

      final bool result = await viewModel.submit();

      expect(result, isTrue);
      expect(viewModel.submitState, ViewState.success);
      expect(viewModel.errorMessage, isEmpty);
      verify(() => mockContactRepo.submitContactForm(any())).called(1);
    });

    test('Handles rate limit error properly', () async {
      viewModel.setName('Jane Smith');
      viewModel.setEmail('jane@company.com');
      viewModel.setMessage('Valid project inquiry message here.');

      when(() => mockContactRepo.submitContactForm(any()))
          .thenAnswer((_) async => const FailureResult<void>(RateLimitFailure()));

      final bool result = await viewModel.submit();

      expect(result, isFalse);
      expect(viewModel.submitState, ViewState.error);
      expect(viewModel.errorMessage, AppStrings.rateLimitError);
    });

    test('Handles network failure with retry-friendly message', () async {
      viewModel.setName('Jane Smith');
      viewModel.setEmail('jane@company.com');
      viewModel.setMessage('Valid project inquiry message here.');

      when(() => mockContactRepo.submitContactForm(any()))
          .thenAnswer((_) async => const FailureResult<void>(NetworkFailure('Connection reset')));

      final bool result = await viewModel.submit();

      expect(result, isFalse);
      expect(viewModel.submitState, ViewState.error);
      expect(viewModel.errorMessage, AppStrings.networkError);
    });

    test('Handles timeout failure gracefully', () async {
      viewModel.setName('Jane Smith');
      viewModel.setEmail('jane@company.com');
      viewModel.setMessage('Valid project inquiry message here.');

      when(() => mockContactRepo.submitContactForm(any()))
          .thenAnswer((_) async => const FailureResult<void>(TimeoutFailure()));

      final bool result = await viewModel.submit();

      expect(result, isFalse);
      expect(viewModel.submitState, ViewState.error);
      expect(viewModel.errorMessage, AppStrings.timeoutError);
    });

    test('Reset form clears all values, errors, and state', () {
      viewModel.setName('Jane');
      viewModel.setEmail('jane@test.com');
      viewModel.resetForm();

      expect(viewModel.name, isEmpty);
      expect(viewModel.email, isEmpty);
      expect(viewModel.submitState, ViewState.idle);
      expect(viewModel.nameError, isNull);
    });
  });
}
