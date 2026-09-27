import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_messages_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockMessagesRepository mockMessagesRepo;

  setUp(() {
    registerTestFallbacks();
    mockMessagesRepo = MockMessagesRepository();
    when(() => mockMessagesRepo.getMessages(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          unreadOnly: any(named: 'unreadOnly'),
          query: any(named: 'query'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenAnswer((_) async =>
        Success<List<ContactMessageModel>>(List<ContactMessageModel>.from(testMessages)));
    when(() => mockMessagesRepo.markAsRead(any()))
        .thenAnswer((_) async => const Success<void>(null));
    when(() => mockMessagesRepo.deleteMessage(any()))
        .thenAnswer((_) async => const Success<void>(null));
  });

  group('AdminMessagesViewModel Tests', () {
    test('Initial loading populates messages and sets state to success', () async {
      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );

      await pumpEventQueue();

      expect(vm.viewState, ViewState.success);
      expect(vm.messages.length, 2);
      expect(vm.unreadOnly, isFalse);
      expect(vm.searchQuery, isEmpty);
      expect(vm.selectedMessage, isNull);
    });

    test('Toggling unreadOnly triggers query with unreadOnly = true', () async {
      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );
      await pumpEventQueue();

      vm.toggleUnreadOnly();
      await pumpEventQueue();

      expect(vm.unreadOnly, isTrue);
      verify(() => mockMessagesRepo.getMessages(
            limit: any(named: 'limit'),
            unreadOnly: true,
            query: any(named: 'query'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).called(1);
    });

    test('Setting search query updates searchQuery and queries with query', () async {
      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );
      await pumpEventQueue();

      vm.setSearchQuery('audit');
      await pumpEventQueue();

      expect(vm.searchQuery, 'audit');
      verify(() => mockMessagesRepo.getMessages(
            limit: any(named: 'limit'),
            unreadOnly: any(named: 'unreadOnly'),
            query: 'audit',
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).called(1);
    });

    test('clearFilters resets search and unreadOnly', () async {
      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );
      await pumpEventQueue();

      vm.setSearchQuery('Novu');
      vm.toggleUnreadOnly();
      expect(vm.searchQuery, 'Novu');
      expect(vm.unreadOnly, isTrue);

      vm.clearFilters();
      await pumpEventQueue();

      expect(vm.searchQuery, isEmpty);
      expect(vm.unreadOnly, isFalse);
    });

    test('Selecting an unread message marks it as read', () async {
      when(() => mockMessagesRepo.markAsRead('msg_1'))
          .thenAnswer((_) async => const Success<void>(null));

      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );
      await pumpEventQueue();

      final ContactMessageModel unreadMessage = vm.messages.firstWhere((ContactMessageModel m) => !m.isRead);
      vm.selectMessage(unreadMessage);
      await pumpEventQueue();

      expect(vm.selectedMessage?.id, unreadMessage.id);
      expect(vm.selectedMessage?.isRead, isTrue);
      expect(vm.messages.firstWhere((ContactMessageModel m) => m.id == unreadMessage.id).isRead, isTrue);
      verify(() => mockMessagesRepo.markAsRead(unreadMessage.id)).called(1);
    });

    test('Deleting message removes it from list and selectedMessage', () async {
      when(() => mockMessagesRepo.deleteMessage('msg_1'))
          .thenAnswer((_) async => const Success<void>(null));

      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );
      await pumpEventQueue();

      vm.selectMessage(vm.messages.first);
      expect(vm.selectedMessage?.id, 'msg_1');

      final bool success = await vm.deleteMessage('msg_1');

      expect(success, isTrue);
      expect(vm.messages.any((ContactMessageModel m) => m.id == 'msg_1'), isFalse);
      expect(vm.selectedMessage, isNull);
    });

    test('Handles repository error on loadMessages', () async {
      when(() => mockMessagesRepo.getMessages(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            unreadOnly: any(named: 'unreadOnly'),
            query: any(named: 'query'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async =>
          const FailureResult<List<ContactMessageModel>>(ServerFailure('Connection error')));

      final AdminMessagesViewModel vm = AdminMessagesViewModel(
        messagesRepository: mockMessagesRepo,
      );
      await pumpEventQueue();

      expect(vm.viewState, ViewState.error);
      expect(vm.errorMessage, 'Connection error');
    });
  });
}
