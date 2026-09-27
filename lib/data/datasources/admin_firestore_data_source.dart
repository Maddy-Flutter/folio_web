import 'dart:convert';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:http/http.dart' as http;

abstract interface class AdminFirestoreDataSource {
  Future<List<ContactMessageModel>> getMessages();
  Future<void> saveMessage(ContactMessageModel message);
  Future<void> markMessageAsRead(String id);
  Future<void> deleteMessage(String id);

  Future<void> trackVisit();
  Future<AnalyticsSummaryModel> getAnalyticsSummary();

  Future<ProfileDraft> getActiveProfile();
  Future<void> publishProfile(ProfileDraft draft);
  Future<List<ProfileVersion>> getVersionHistory();
  Future<ProfileDraft> revertToVersion(String versionId);
}

/// Hybrid Firestore REST and resilient In-Memory datasource.
///
/// If [projectId] is specified and network connectivity is active, queries
/// Firestore documents via Google Cloud Firestore v1 REST endpoints.
/// Otherwise, gracefully serves and mutates in-memory data for instant local runs and testing.
final class AdminFirestoreDataSourceImpl implements AdminFirestoreDataSource {
  AdminFirestoreDataSourceImpl({
    http.Client? httpClient,
    this.projectId = _defaultProjectId,
  }) : _httpClient = httpClient ?? http.Client();

  static final AdminFirestoreDataSourceImpl instance = AdminFirestoreDataSourceImpl();

  static const String _defaultProjectId = String.fromEnvironment(
    'FIRESTORE_PROJECT_ID',
  );

  final http.Client _httpClient;
  final String projectId;

  // In-Memory state store seeded with realistic demo data
  final List<ContactMessageModel> _inMemoryMessages = <ContactMessageModel>[
    ContactMessageModel(
      id: 'msg_001',
      name: 'Sarah Connor',
      email: 'sarah.c@cyberdyne.io',
      subject: 'Design System & Mobile App Redesign',
      message:
          'Hi Eliott, we reviewed your Novu dashboard case study and were thoroughly impressed. We would love to discuss leading our product design sprint for Q4.',
      receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ContactMessageModel(
      id: 'msg_002',
      name: 'Marcus Vance',
      email: 'm.vance@finlo-capital.com',
      subject: 'Fintech Landing Page Consultation',
      message:
          'Loved the micro-interactions on your portfolio. Could you share your availability for a 4-week landing page build starting next month?',
      receivedAt: DateTime.now().subtract(const Duration(hours: 14)),
    ),
    ContactMessageModel(
      id: 'msg_003',
      name: 'Elena Rostova',
      email: 'elena@aurora-labs.de',
      subject: 'SaaS Dashboard Contract',
      message:
          'Our team in Berlin is looking for a senior frontend contractor proficient in Flutter Web and modern design systems. Let us know if you have time for a quick intro call.',
      receivedAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  int _inMemoryVisitorCount = 1420;
  int _inMemoryWeeklyVisitorCount = 285;

  ProfileDraft _activeProfile = ProfileDraft.initialDefault;
  final List<ProfileVersion> _versionHistory = <ProfileVersion>[
    ProfileVersion(
      versionId: 'v1_initial',
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      draft: ProfileDraft.initialDefault,
    ),
  ];

  @override
  Future<List<ContactMessageModel>> getMessages() async {
    if (projectId.isNotEmpty) {
      try {
        final Uri url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/messages',
        );
        final http.Response res = await _httpClient.get(url);
        if (res.statusCode == 200) {
          final Map<String, dynamic> json = jsonDecode(res.body) as Map<String, dynamic>;
          final List<dynamic>? documents = json['documents'] as List<dynamic>?;
          if (documents != null) {
            final List<ContactMessageModel> remoteMessages = documents.map((dynamic doc) {
              final Map<String, dynamic> fields =
                  (doc as Map<String, dynamic>)['fields'] as Map<String, dynamic>? ??
                      <String, dynamic>{};
              final String namePath = doc['name'] as String? ?? '';
              final String id = namePath.split('/').last;
              return ContactMessageModel(
                id: id,
                name: (fields['name']?['stringValue'] as String?) ?? '',
                email: (fields['email']?['stringValue'] as String?) ?? '',
                subject: (fields['subject']?['stringValue'] as String?) ?? '',
                message: (fields['message']?['stringValue'] as String?) ?? '',
                receivedAt: DateTime.tryParse(
                      (fields['receivedAt']?['timestampValue'] as String?) ?? '',
                    ) ??
                    DateTime.now(),
                isRead: (fields['isRead']?['booleanValue'] as bool?) ?? false,
              );
            }).toList();
            remoteMessages.sort((ContactMessageModel a, ContactMessageModel b) =>
                b.receivedAt.compareTo(a.receivedAt));
            return remoteMessages;
          }
        }
      } catch (_) {
        // Fall back to in-memory store
      }
    }
    _inMemoryMessages.sort((ContactMessageModel a, ContactMessageModel b) =>
        b.receivedAt.compareTo(a.receivedAt));
    return List<ContactMessageModel>.unmodifiable(_inMemoryMessages);
  }

  @override
  Future<void> saveMessage(ContactMessageModel message) async {
    _inMemoryMessages.insert(0, message);

    if (projectId.isNotEmpty) {
      try {
        final Uri url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/messages?documentId=${message.id}',
        );
        final Map<String, dynamic> body = <String, dynamic>{
          'fields': <String, dynamic>{
            'name': <String, dynamic>{'stringValue': message.name},
            'email': <String, dynamic>{'stringValue': message.email},
            'subject': <String, dynamic>{'stringValue': message.subject},
            'message': <String, dynamic>{'stringValue': message.message},
            'receivedAt': <String, dynamic>{'timestampValue': message.receivedAt.toUtc().toIso8601String()},
            'isRead': <String, dynamic>{'booleanValue': message.isRead},
          },
        };
        await _httpClient.post(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
      } catch (_) {
        // Kept in in-memory store
      }
    }
  }

  @override
  Future<void> markMessageAsRead(String id) async {
    final int index = _inMemoryMessages.indexWhere((ContactMessageModel m) => m.id == id);
    if (index != -1) {
      _inMemoryMessages[index] = _inMemoryMessages[index].copyWith(isRead: true);
    }

    if (projectId.isNotEmpty) {
      try {
        final Uri url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/messages/$id?updateMask.fieldPaths=isRead',
        );
        final Map<String, dynamic> body = <String, dynamic>{
          'fields': <String, dynamic>{
            'isRead': <String, dynamic>{'booleanValue': true},
          },
        };
        await _httpClient.patch(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
      } catch (_) {
        // Handled locally
      }
    }
  }

  @override
  Future<void> deleteMessage(String id) async {
    _inMemoryMessages.removeWhere((ContactMessageModel m) => m.id == id);

    if (projectId.isNotEmpty) {
      try {
        final Uri url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/messages/$id',
        );
        await _httpClient.delete(url);
      } catch (_) {
        // Handled locally
      }
    }
  }

  @override
  Future<void> trackVisit() async {
    _inMemoryVisitorCount += 1;
    _inMemoryWeeklyVisitorCount += 1;

    if (projectId.isNotEmpty) {
      try {
        final Uri url = Uri.parse(
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/analytics/visitors',
        );
        final Map<String, dynamic> body = <String, dynamic>{
          'fields': <String, dynamic>{
            'totalVisitors': <String, dynamic>{'integerValue': _inMemoryVisitorCount.toString()},
            'updatedAt': <String, dynamic>{'timestampValue': DateTime.now().toUtc().toIso8601String()},
          },
        };
        await _httpClient.patch(
          url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
      } catch (_) {
        // Tracked in local in-memory store
      }
    }
  }

  @override
  Future<AnalyticsSummaryModel> getAnalyticsSummary() async {
    final int unread = _inMemoryMessages.where((ContactMessageModel m) => !m.isRead).length;
    return AnalyticsSummaryModel(
      totalVisitors: _inMemoryVisitorCount,
      visitorsThisWeek: _inMemoryWeeklyVisitorCount,
      totalMessages: _inMemoryMessages.length,
      unreadMessages: unread,
    );
  }

  @override
  Future<ProfileDraft> getActiveProfile() async {
    return _activeProfile;
  }

  @override
  Future<void> publishProfile(ProfileDraft draft) async {
    _activeProfile = draft;
    final String versionId = 'v_${DateTime.now().millisecondsSinceEpoch}';
    final ProfileVersion version = ProfileVersion(
      versionId: versionId,
      publishedAt: DateTime.now(),
      draft: draft,
    );

    // Keep last 5 published profile versions
    _versionHistory.insert(0, version);
    if (_versionHistory.length > 5) {
      _versionHistory.removeRange(5, _versionHistory.length);
    }
  }

  @override
  Future<List<ProfileVersion>> getVersionHistory() async {
    return List<ProfileVersion>.unmodifiable(_versionHistory);
  }

  @override
  Future<ProfileDraft> revertToVersion(String versionId) async {
    final ProfileVersion version = _versionHistory.firstWhere(
      (ProfileVersion v) => v.versionId == versionId,
      orElse: () => throw const CacheFailure('Version not found in history'),
    );
    _activeProfile = version.draft;
    return _activeProfile;
  }
}
