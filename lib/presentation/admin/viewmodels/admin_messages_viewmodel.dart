import 'package:flutter/foundation.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/domain/repositories/messages_repository.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';

final class AdminMessagesViewModel extends ChangeNotifier {
  AdminMessagesViewModel({required MessagesRepository messagesRepository})
      : _messagesRepository = messagesRepository {
    loadMessages();
  }

  final MessagesRepository _messagesRepository;

  ViewState _viewState = ViewState.idle;
  String _errorMessage = '';
  List<ContactMessageModel> _messages = <ContactMessageModel>[];
  ContactMessageModel? _selectedMessage;

  bool _unreadOnly = false;
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  int _page = 1;
  static const int _pageSize = 25;
  bool _isDisposed = false;

  ViewState get viewState => _viewState;
  bool get isLoading => _viewState == ViewState.loading;
  String get errorMessage => _errorMessage;
  List<ContactMessageModel> get messages => _messages;
  ContactMessageModel? get selectedMessage => _selectedMessage;

  bool get unreadOnly => _unreadOnly;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  int get page => _page;

  Future<void> loadMessages() async {
    _viewState = ViewState.loading;
    _errorMessage = '';
    _notify();

    final Result<List<ContactMessageModel>> result =
        await _messagesRepository.getMessages(
      page: _page,
      limit: _pageSize,
      unreadOnly: _unreadOnly,
      query: _searchQuery,
      startDate: _startDate,
      endDate: _endDate,
    );

    result.when(
      success: (List<ContactMessageModel> list) {
        _messages = list;
        _viewState = ViewState.success;
      },
      failure: (failure) {
        _viewState = ViewState.error;
        _errorMessage = failure.message;
      },
    );

    _notify();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _page = 1;
    loadMessages();
  }

  void toggleUnreadOnly() {
    _unreadOnly = !_unreadOnly;
    _page = 1;
    loadMessages();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _page = 1;
    loadMessages();
  }

  void clearFilters() {
    _unreadOnly = false;
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    _page = 1;
    loadMessages();
  }

  void selectMessage(ContactMessageModel? message) {
    _selectedMessage = message;
    if (message != null && !message.isRead) {
      markAsRead(message.id);
    }
    _notify();
  }

  Future<void> markAsRead(String id) async {
    final Result<void> result = await _messagesRepository.markAsRead(id);
    if (result.isSuccess) {
      final int idx = _messages.indexWhere((ContactMessageModel m) => m.id == id);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(isRead: true);
        if (_selectedMessage?.id == id) {
          _selectedMessage = _selectedMessage!.copyWith(isRead: true);
        }
        _notify();
      }
    }
  }

  Future<bool> deleteMessage(String id) async {
    final Result<void> result = await _messagesRepository.deleteMessage(id);
    if (result.isSuccess) {
      _messages.removeWhere((ContactMessageModel m) => m.id == id);
      if (_selectedMessage?.id == id) {
        _selectedMessage = null;
      }
      _notify();
      return true;
    }
    return false;
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
