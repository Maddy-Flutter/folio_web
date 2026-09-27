import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:follio/core/constants/app_constants.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';

abstract interface class PortfolioLocalDataSource {
  Future<List<ServiceModel>> getServices();
  Future<List<ProjectModel>> getProjects();
  Future<List<TestimonialModel>> getTestimonials();
  Future<List<BlogPostModel>> getBlogPosts();
}

final class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  const PortfolioLocalDataSourceImpl({AssetBundle? bundle})
      : _bundle = bundle;

  final AssetBundle? _bundle;

  AssetBundle get _effectiveBundle => _bundle ?? rootBundle;

  @override
  Future<List<ServiceModel>> getServices() async {
    final String raw = await _effectiveBundle.loadString(AppConstants.servicesJsonPath);
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! List<dynamic>) return <ServiceModel>[];
    return decoded
        .map((dynamic e) => ServiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final String raw = await _effectiveBundle.loadString(AppConstants.projectsJsonPath);
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! List<dynamic>) return <ProjectModel>[];
    return decoded
        .map((dynamic e) => ProjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TestimonialModel>> getTestimonials() async {
    final String raw = await _effectiveBundle.loadString(AppConstants.testimonialsJsonPath);
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! List<dynamic>) return <TestimonialModel>[];
    return decoded
        .map((dynamic e) => TestimonialModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BlogPostModel>> getBlogPosts() async {
    final String raw = await _effectiveBundle.loadString(AppConstants.postsJsonPath);
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! List<dynamic>) return <BlogPostModel>[];
    return decoded
        .map((dynamic e) => BlogPostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
