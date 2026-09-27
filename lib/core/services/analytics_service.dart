import 'package:follio/domain/repositories/analytics_repository.dart';

final class AnalyticsService {
  AnalyticsService({required AnalyticsRepository analyticsRepository})
      : _analyticsRepository = analyticsRepository;

  final AnalyticsRepository _analyticsRepository;
  bool _hasTrackedVisit = false;

  /// Tracks a public site visit once per application launch/page load.
  Future<void> trackVisit() async {
    if (_hasTrackedVisit) return;
    _hasTrackedVisit = true;
    await _analyticsRepository.trackVisit();
  }
}
