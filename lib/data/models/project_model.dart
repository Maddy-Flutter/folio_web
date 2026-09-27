import 'package:flutter/material.dart';

@immutable
final class ProjectStatModel {
  const ProjectStatModel({
    required this.label,
    required this.value,
  });

  factory ProjectStatModel.fromJson(Map<String, dynamic> json) {
    return ProjectStatModel(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  final String label;
  final String value;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'label': label,
        'value': value,
      };
}

@immutable
final class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    required this.categoryLabel,
    required this.tags,
    required this.excerpt,
    required this.fullDescription,
    required this.client,
    required this.role,
    required this.timeline,
    required this.deliverables,
    required this.coverImage,
    required this.isFeatured,
    required this.year,
    required this.stats,
    this.challenge = '',
    this.solution = '',
    this.testimonialQuote = '',
    this.testimonialAuthor = '',
    this.testimonialRole = '',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? rawTags = json['tags'] as List<dynamic>?;
    final List<dynamic>? rawDeliverables = json['deliverables'] as List<dynamic>?;
    final List<dynamic>? rawStats = json['stats'] as List<dynamic>?;

    return ProjectModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      categoryLabel: json['categoryLabel'] as String? ?? '',
      tags: rawTags?.map((dynamic e) => e.toString()).toList() ?? <String>[],
      excerpt: json['excerpt'] as String? ?? '',
      fullDescription: json['fullDescription'] as String? ?? '',
      client: json['client'] as String? ?? '',
      role: json['role'] as String? ?? '',
      timeline: json['timeline'] as String? ?? '',
      deliverables: rawDeliverables?.map((dynamic e) => e.toString()).toList() ?? <String>[],
      coverImage: json['coverImage'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      year: json['year'] as String? ?? '',
      stats: rawStats
              ?.map((dynamic e) => ProjectStatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <ProjectStatModel>[],
      challenge: json['challenge'] as String? ?? '',
      solution: json['solution'] as String? ?? '',
      testimonialQuote: json['testimonialQuote'] as String? ?? '',
      testimonialAuthor: json['testimonialAuthor'] as String? ?? '',
      testimonialRole: json['testimonialRole'] as String? ?? '',
    );
  }

  final String id;
  final String slug;
  final String title;
  final String category;
  final String categoryLabel;
  final List<String> tags;
  final String excerpt;
  final String fullDescription;
  final String client;
  final String role;
  final String timeline;
  final List<String> deliverables;
  final String coverImage;
  final bool isFeatured;
  final String year;
  final List<ProjectStatModel> stats;
  final String challenge;
  final String solution;
  final String testimonialQuote;
  final String testimonialAuthor;
  final String testimonialRole;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'slug': slug,
        'title': title,
        'category': category,
        'categoryLabel': categoryLabel,
        'tags': tags,
        'excerpt': excerpt,
        'fullDescription': fullDescription,
        'client': client,
        'role': role,
        'timeline': timeline,
        'deliverables': deliverables,
        'coverImage': coverImage,
        'isFeatured': isFeatured,
        'year': year,
        'stats': stats.map((ProjectStatModel s) => s.toJson()).toList(),
        'challenge': challenge,
        'solution': solution,
        'testimonialQuote': testimonialQuote,
        'testimonialAuthor': testimonialAuthor,
        'testimonialRole': testimonialRole,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
