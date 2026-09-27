import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/contact_message_model.dart';

abstract interface class MessagesRepository {
  Future<Result<List<ContactMessageModel>>> getMessages({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
    String? query,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Result<void>> markAsRead(String messageId);

  Future<Result<void>> deleteMessage(String messageId);

  Future<Result<void>> saveMessage(ContactMessageModel message);

  Future<Result<int>> getUnreadCount();
}
