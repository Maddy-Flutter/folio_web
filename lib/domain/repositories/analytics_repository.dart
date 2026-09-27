import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/analytics_summary_model.dart';

abstract interface class AnalyticsRepository {
  Future<Result<void>> trackVisit();

  Future<Result<AnalyticsSummaryModel>> getSummary();
}
