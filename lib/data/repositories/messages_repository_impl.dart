import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/admin_firestore_data_source.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/domain/repositories/messages_repository.dart';

final class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl({
    required AdminFirestoreDataSource dataSource,
  }) : _dataSource = dataSource;

  final AdminFirestoreDataSource _dataSource;

  @override
  Future<Result<List<ContactMessageModel>>> getMessages({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
    String? query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final List<ContactMessageModel> allMessages = await _dataSource.getMessages();

      Iterable<ContactMessageModel> filtered = allMessages;

      if (unreadOnly) {
        filtered = filtered.where((ContactMessageModel m) => !m.isRead);
      }

      if (query != null && query.trim().isNotEmpty) {
        final String q = query.trim().toLowerCase();
        filtered = filtered.where((ContactMessageModel m) {
          return m.name.toLowerCase().contains(q) ||
              m.email.toLowerCase().contains(q) ||
              m.subject.toLowerCase().contains(q) ||
              m.message.toLowerCase().contains(q);
        });
      }

      if (startDate != null) {
        filtered = filtered.where((ContactMessageModel m) =>
            m.receivedAt.isAfter(startDate) ||
            m.receivedAt.isAtSameMomentAs(startDate));
      }

      if (endDate != null) {
        filtered = filtered.where((ContactMessageModel m) =>
            m.receivedAt.isBefore(endDate) ||
            m.receivedAt.isAtSameMomentAs(endDate));
      }

      final List<ContactMessageModel> list = filtered.toList();
      final int startIndex = (page - 1) * limit;
      if (startIndex >= list.length) {
        return const Success<List<ContactMessageModel>>(<ContactMessageModel>[]);
      }

      final int endIndex = (startIndex + limit) > list.length
          ? list.length
          : (startIndex + limit);

      return Success<List<ContactMessageModel>>(
        list.sublist(startIndex, endIndex),
      );
    } catch (e) {
      return FailureResult<List<ContactMessageModel>>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String messageId) async {
    try {
      await _dataSource.markMessageAsRead(messageId);
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteMessage(String messageId) async {
    try {
      await _dataSource.deleteMessage(messageId);
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveMessage(ContactMessageModel message) async {
    try {
      await _dataSource.saveMessage(message);
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    try {
      final List<ContactMessageModel> messages = await _dataSource.getMessages();
      final int unread = messages.where((ContactMessageModel m) => !m.isRead).length;
      return Success<int>(unread);
    } catch (e) {
      return FailureResult<int>(CacheFailure(e.toString()));
    }
  }
}
