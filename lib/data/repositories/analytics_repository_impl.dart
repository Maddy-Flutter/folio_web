import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/admin_firestore_data_source.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/domain/repositories/analytics_repository.dart';

final class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl({
    required AdminFirestoreDataSource dataSource,
  }) : _dataSource = dataSource;

  final AdminFirestoreDataSource _dataSource;

  @override
  Future<Result<void>> trackVisit() async {
    try {
      await _dataSource.trackVisit();
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<AnalyticsSummaryModel>> getSummary() async {
    try {
      final AnalyticsSummaryModel summary = await _dataSource.getAnalyticsSummary();
      return Success<AnalyticsSummaryModel>(summary);
    } catch (e) {
      return FailureResult<AnalyticsSummaryModel>(CacheFailure(e.toString()));
    }
  }
}
