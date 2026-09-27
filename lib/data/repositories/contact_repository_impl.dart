import 'package:follio/core/constants/app_constants.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/contact_remote_data_source.dart';
import 'package:follio/data/datasources/preferences_local_data_source.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/data/models/contact_submission_dto.dart';
import 'package:follio/domain/repositories/contact_repository.dart';
import 'package:follio/domain/repositories/messages_repository.dart';

final class ContactRepositoryImpl implements ContactRepository {
  ContactRepositoryImpl({
    required ContactRemoteDataSource remoteDataSource,
    required PreferencesLocalDataSource preferencesDataSource,
    MessagesRepository? messagesRepository,
  })  : _remoteDataSource = remoteDataSource,
        _preferencesDataSource = preferencesDataSource,
        _messagesRepository = messagesRepository;

  final ContactRemoteDataSource _remoteDataSource;
  final PreferencesLocalDataSource _preferencesDataSource;
  final MessagesRepository? _messagesRepository;

  @override
  Future<bool> isRateLimited() async {
    final int? lastSubmitMs = await _preferencesDataSource.getLastSubmitTimestamp();
    if (lastSubmitMs == null) return false;

    final int nowMs = DateTime.now().millisecondsSinceEpoch;
    final int diffMs = nowMs - lastSubmitMs;
    return diffMs < AppConstants.rateLimitCooldown.inMilliseconds;
  }

  @override
  Future<Result<void>> submitContactForm(ContactSubmissionDto submission) async {
    // 1. Check honeypot: Trap bot silently
    if (submission.isHoneypotTriggered) {
      return const Success<void>(null);
    }

    // 2. Validate input fields
    if (!submission.isValid) {
      final String? nameErr = submission.validateName();
      if (nameErr != null) return FailureResult<void>(ValidationFailure(nameErr));

      final String? emailErr = submission.validateEmail();
      if (emailErr != null) return FailureResult<void>(ValidationFailure(emailErr));

      final String? subjectErr = submission.validateSubject();
      if (subjectErr != null) return FailureResult<void>(ValidationFailure(subjectErr));

      final String? messageErr = submission.validateMessage();
      if (messageErr != null) return FailureResult<void>(ValidationFailure(messageErr));

      return const FailureResult<void>(ValidationFailure('Invalid form inputs.'));
    }

    // 3. Check client-side rate limit
    if (await isRateLimited()) {
      return const FailureResult<void>(RateLimitFailure());
    }

    // 4. Send via EmailJS Remote DataSource
    try {
      await _remoteDataSource.sendInquiry(submission);

      // 5. Persist submission timestamp upon success
      final int nowMs = DateTime.now().millisecondsSinceEpoch;
      await _preferencesDataSource.setLastSubmitTimestamp(nowMs);

      // 6. Write message to persistent store for admin dashboard review
      if (_messagesRepository != null) {
        final ContactMessageModel messageModel = ContactMessageModel(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          name: submission.name,
          email: submission.email,
          subject: submission.subject.isEmpty ? 'General Inquiry' : submission.subject,
          message: submission.message,
          receivedAt: DateTime.now(),
        );
        await _messagesRepository.saveMessage(messageModel);
      }

      return const Success<void>(null);
    } on Failure catch (f) {
      return FailureResult<void>(f);
    } catch (e) {
      return FailureResult<void>(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveAndNotify(ContactSubmissionDto submission) {
    return submitContactForm(submission);
  }
}
