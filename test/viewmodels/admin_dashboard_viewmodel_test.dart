import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockAnalyticsRepository mockAnalyticsRepo;
  late MockMessagesRepository mockMessagesRepo;

  setUp(() {
    registerTestFallbacks();
    mockAnalyticsRepo = MockAnalyticsRepository();
    mockMessagesRepo = MockMessagesRepository();
  });

  group('AdminDashboardViewModel Tests', () {
    test('Initial loading populates summary and recent messages on success',
        () async {
      when(() => mockAnalyticsRepo.getSummary())
          .thenAnswer((_) async => const Success<AnalyticsSummaryModel>(testAnalyticsSummary));
      when(() => mockMessagesRepo.getMessages(limit: 5))
          .thenAnswer((_) async => Success<List<ContactMessageModel>>(testMessages));

      final AdminDashboardViewModel vm = AdminDashboardViewModel(
        analyticsRepository: mockAnalyticsRepo,
        messagesRepository: mockMessagesRepo,
      );

      await pumpEventQueue();

      expect(vm.viewState, ViewState.success);
      expect(vm.isLoading, isFalse);
      expect(vm.summary.totalVisitors, 1540);
      expect(vm.summary.visitorsThisWeek, 320);
      expect(vm.summary.totalMessages, 12);
      expect(vm.summary.unreadMessages, 3);
      expect(vm.recentMessages.length, testMessages.length);
      expect(vm.errorMessage, isEmpty);
    });

    test('Handles analytics failure gracefully', () async {
      when(() => mockAnalyticsRepo.getSummary())
          .thenAnswer((_) async =>
          const FailureResult<AnalyticsSummaryModel>(ServerFailure('Failed to fetch analytics')));
      when(() => mockMessagesRepo.getMessages(limit: 5))
          .thenAnswer((_) async => Success<List<ContactMessageModel>>(testMessages));

      final AdminDashboardViewModel vm = AdminDashboardViewModel(
        analyticsRepository: mockAnalyticsRepo,
        messagesRepository: mockMessagesRepo,
      );

      await pumpEventQueue();

      expect(vm.viewState, ViewState.error);
      expect(vm.errorMessage, 'Failed to fetch analytics');
    });

    test('Handles messages failure gracefully', () async {
      when(() => mockAnalyticsRepo.getSummary())
          .thenAnswer((_) async => const Success<AnalyticsSummaryModel>(testAnalyticsSummary));
      when(() => mockMessagesRepo.getMessages(limit: 5))
          .thenAnswer((_) async =>
          const FailureResult<List<ContactMessageModel>>(ServerFailure('Failed to fetch messages')));

      final AdminDashboardViewModel vm = AdminDashboardViewModel(
        analyticsRepository: mockAnalyticsRepo,
        messagesRepository: mockMessagesRepo,
      );

      await pumpEventQueue();

      expect(vm.viewState, ViewState.error);
      expect(vm.errorMessage, 'Failed to fetch messages');
    });
  });
}
