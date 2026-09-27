import 'package:flutter/material.dart';

@immutable
final class TestimonialModel {
  const TestimonialModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.avatarUrl,
    required this.rating,
    required this.quote,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      company: json['company'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      quote: json['quote'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String role;
  final String company;
  final String avatarUrl;
  final int rating;
  final String quote;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'role': role,
        'company': company,
        'avatarUrl': avatarUrl,
        'rating': rating,
        'quote': quote,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestimonialModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
