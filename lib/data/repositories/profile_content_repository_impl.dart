import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/admin_firestore_data_source.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';

final class ProfileContentRepositoryImpl implements ProfileContentRepository {
  ProfileContentRepositoryImpl({
    required AdminFirestoreDataSource dataSource,
  }) : _dataSource = dataSource;

  final AdminFirestoreDataSource _dataSource;
  ProfileDraft? _cachedProfile;

  @override
  Future<Result<ProfileDraft>> getActiveProfile() async {
    try {
      if (_cachedProfile != null) {
        return Success<ProfileDraft>(_cachedProfile!);
      }
      final ProfileDraft profile = await _dataSource.getActiveProfile();
      _cachedProfile = profile;
      return Success<ProfileDraft>(profile);
    } catch (e) {
      return FailureResult<ProfileDraft>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> publishProfile(ProfileDraft draft) async {
    try {
      await _dataSource.publishProfile(draft);
      // Invalidate in-memory cache so public views immediately reflect updates
      _cachedProfile = draft;
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProfileVersion>>> getVersionHistory() async {
    try {
      final List<ProfileVersion> history = await _dataSource.getVersionHistory();
      return Success<List<ProfileVersion>>(history);
    } catch (e) {
      return FailureResult<List<ProfileVersion>>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<ProfileDraft>> revertToVersion(String versionId) async {
    try {
      final ProfileDraft reverted = await _dataSource.revertToVersion(versionId);
      // Invalidate and update cache
      _cachedProfile = reverted;
      return Success<ProfileDraft>(reverted);
    } catch (e) {
      return FailureResult<ProfileDraft>(CacheFailure(e.toString()));
    }
  }
}
