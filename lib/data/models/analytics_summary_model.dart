final class AnalyticsSummaryModel {
  const AnalyticsSummaryModel({
    required this.totalVisitors,
    required this.visitorsThisWeek,
    required this.totalMessages,
    required this.unreadMessages,
  });

  final int totalVisitors;
  final int visitorsThisWeek;
  final int totalMessages;
  final int unreadMessages;

  AnalyticsSummaryModel copyWith({
    int? totalVisitors,
    int? visitorsThisWeek,
    int? totalMessages,
    int? unreadMessages,
  }) {
    return AnalyticsSummaryModel(
      totalVisitors: totalVisitors ?? this.totalVisitors,
      visitorsThisWeek: visitorsThisWeek ?? this.visitorsThisWeek,
      totalMessages: totalMessages ?? this.totalMessages,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalVisitors': totalVisitors,
      'visitorsThisWeek': visitorsThisWeek,
      'totalMessages': totalMessages,
      'unreadMessages': unreadMessages,
    };
  }

  factory AnalyticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummaryModel(
      totalVisitors: json['totalVisitors'] as int? ?? 0,
      visitorsThisWeek: json['visitorsThisWeek'] as int? ?? 0,
      totalMessages: json['totalMessages'] as int? ?? 0,
      unreadMessages: json['unreadMessages'] as int? ?? 0,
    );
  }

  static const AnalyticsSummaryModel empty = AnalyticsSummaryModel(
    totalVisitors: 0,
    visitorsThisWeek: 0,
    totalMessages: 0,
    unreadMessages: 0,
  );
}
