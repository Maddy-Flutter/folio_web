import 'package:flutter/material.dart';

@immutable
final class BlogPostModel {
  const BlogPostModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    required this.date,
    required this.readTime,
    required this.excerpt,
    required this.content,
    required this.coverImage,
    required this.isFeatured,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      date: json['date'] as String? ?? '',
      readTime: json['readTime'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      content: json['content'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  final String id;
  final String slug;
  final String title;
  final String category;
  final String date;
  final String readTime;
  final String excerpt;
  final String content;
  final String coverImage;
  final bool isFeatured;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'slug': slug,
        'title': title,
        'category': category,
        'date': date,
        'readTime': readTime,
        'excerpt': excerpt,
        'content': content,
        'coverImage': coverImage,
        'isFeatured': isFeatured,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPostModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
