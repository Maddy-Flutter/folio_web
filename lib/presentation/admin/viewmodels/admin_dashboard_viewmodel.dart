import 'package:flutter/foundation.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/domain/repositories/analytics_repository.dart';
import 'package:follio/domain/repositories/messages_repository.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';

final class AdminDashboardViewModel extends ChangeNotifier {
  AdminDashboardViewModel({
    required AnalyticsRepository analyticsRepository,
    required MessagesRepository messagesRepository,
  })  : _analyticsRepository = analyticsRepository,
        _messagesRepository = messagesRepository {
    loadDashboard();
  }

  final AnalyticsRepository _analyticsRepository;
  final MessagesRepository _messagesRepository;

  ViewState _viewState = ViewState.idle;
  String _errorMessage = '';
  AnalyticsSummaryModel _summary = AnalyticsSummaryModel.empty;
  List<ContactMessageModel> _recentMessages = <ContactMessageModel>[];
  bool _isDisposed = false;

  ViewState get viewState => _viewState;
  bool get isLoading => _viewState == ViewState.loading;
  String get errorMessage => _errorMessage;
  AnalyticsSummaryModel get summary => _summary;
  List<ContactMessageModel> get recentMessages => _recentMessages;

  Future<void> loadDashboard() async {
    _viewState = ViewState.loading;
    _errorMessage = '';
    _notify();

    final Result<AnalyticsSummaryModel> analyticsResult =
        await _analyticsRepository.getSummary();
    final Result<List<ContactMessageModel>> messagesResult =
        await _messagesRepository.getMessages(limit: 5);

    if (analyticsResult.isSuccess && messagesResult.isSuccess) {
      _summary = analyticsResult.valueOrNull ?? AnalyticsSummaryModel.empty;
      _recentMessages = messagesResult.valueOrNull ?? <ContactMessageModel>[];
      _viewState = ViewState.success;
    } else {
      _viewState = ViewState.error;
      _errorMessage = analyticsResult.failureOrNull?.message ??
          messagesResult.failureOrNull?.message ??
          'Unable to load dashboard data.';
    }

    _notify();
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
