import 'package:flutter/material.dart';

@immutable
final class ContactSubmissionDto {
  const ContactSubmissionDto({
    required this.name,
    required this.email,
    this.subject = '',
    required this.message,
    this.honeypot = '',
  });

  final String name;
  final String email;
  final String subject;
  final String message;
  final String honeypot;

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  bool get isHoneypotTriggered => honeypot.trim().isNotEmpty;

  String? validateName() {
    final String trimmed = name.trim();
    if (trimmed.length < 2 || trimmed.length > 60) {
      return 'Please enter your name (2–60 characters).';
    }
    return null;
  }

  String? validateEmail() {
    final String trimmed = email.trim();
    if (trimmed.isEmpty || !_emailRegExp.hasMatch(trimmed)) {
      return 'Please provide a valid email address.';
    }
    return null;
  }

  String? validateSubject() {
    final String trimmed = subject.trim();
    if (trimmed.length > 120) {
      return 'Subject cannot exceed 120 characters.';
    }
    return null;
  }

  String? validateMessage() {
    final String trimmed = message.trim();
    if (trimmed.length < 10 || trimmed.length > 2000) {
      return 'Message must be between 10 and 2000 characters.';
    }
    return null;
  }

  bool get isValid =>
      validateName() == null &&
      validateEmail() == null &&
      validateSubject() == null &&
      validateMessage() == null;

  Map<String, dynamic> toEmailJsParams() {
    return <String, dynamic>{
      'from_name': name.trim(),
      'from_email': email.trim(),
      'subject': subject.trim().isEmpty ? 'Portfolio Contact Inquiry' : subject.trim(),
      'message': message.trim(),
      'reply_to': email.trim(),
    };
  }
}
