import 'package:flutter/material.dart';

@immutable
final class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.iconKey,
    required this.title,
    required this.description,
    required this.isHighlighted,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );
  }

  final String id;
  final String iconKey;
  final String title;
  final String description;
  final bool isHighlighted;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'iconKey': iconKey,
        'title': title,
        'description': description,
        'isHighlighted': isHighlighted,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
