final class ContactMessageModel {
  const ContactMessageModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.receivedAt,
    this.isRead = false,
  });

  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final DateTime receivedAt;
  final bool isRead;

  ContactMessageModel copyWith({
    String? id,
    String? name,
    String? email,
    String? subject,
    String? message,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return ContactMessageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'receivedAt': receivedAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory ContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactMessageModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      receivedAt: DateTime.tryParse(json['receivedAt'] as String? ?? '') ?? DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
