import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/profile_content_model.dart';

abstract interface class ProfileContentRepository {
  Future<Result<ProfileDraft>> getActiveProfile();

  Future<Result<void>> publishProfile(ProfileDraft draft);

  Future<Result<List<ProfileVersion>>> getVersionHistory();

  Future<Result<ProfileDraft>> revertToVersion(String versionId);
}
