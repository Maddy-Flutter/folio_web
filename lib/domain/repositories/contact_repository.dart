import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/contact_submission_dto.dart';

abstract interface class ContactRepository {
  Future<Result<void>> submitContactForm(ContactSubmissionDto submission);
  Future<Result<void>> saveAndNotify(ContactSubmissionDto submission);
  Future<bool> isRateLimited();
}
