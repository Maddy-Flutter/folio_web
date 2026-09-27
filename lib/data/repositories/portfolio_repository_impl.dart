import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/portfolio_local_data_source.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/domain/repositories/portfolio_repository.dart';

final class PortfolioRepositoryImpl implements PortfolioRepository {
  PortfolioRepositoryImpl({required PortfolioLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final PortfolioLocalDataSource _localDataSource;

  List<ServiceModel>? _cachedServices;
  List<ProjectModel>? _cachedProjects;
  List<TestimonialModel>? _cachedTestimonials;
  List<BlogPostModel>? _cachedBlogPosts;

  @override
  Future<Result<List<ServiceModel>>> getServices() async {
    try {
      if (_cachedServices != null) {
        return Success<List<ServiceModel>>(_cachedServices!);
      }
      final List<ServiceModel> list = await _localDataSource.getServices();
      _cachedServices = list;
      return Success<List<ServiceModel>>(list);
    } catch (e) {
      return FailureResult<List<ServiceModel>>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProjectModel>>> getProjects() async {
    try {
      if (_cachedProjects != null) {
        return Success<List<ProjectModel>>(_cachedProjects!);
      }
      final List<ProjectModel> list = await _localDataSource.getProjects();
      _cachedProjects = list;
      return Success<List<ProjectModel>>(list);
    } catch (e) {
      return FailureResult<List<ProjectModel>>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<ProjectModel>> getProjectBySlug(String slug) async {
    try {
      final Result<List<ProjectModel>> projectsResult = await getProjects();
      return switch (projectsResult) {
        Success(:final data) => () {
            final ProjectModel project = data.firstWhere(
              (ProjectModel p) => p.slug.toLowerCase() == slug.toLowerCase(),
              orElse: () => throw const CacheFailure('Project not found'),
            );
            return Success<ProjectModel>(project);
          }(),
        FailureResult(:final failure) => FailureResult<ProjectModel>(failure),
      };
    } catch (e) {
      return FailureResult<ProjectModel>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TestimonialModel>>> getTestimonials() async {
    try {
      if (_cachedTestimonials != null) {
        return Success<List<TestimonialModel>>(_cachedTestimonials!);
      }
      final List<TestimonialModel> list = await _localDataSource.getTestimonials();
      _cachedTestimonials = list;
      return Success<List<TestimonialModel>>(list);
    } catch (e) {
      return FailureResult<List<TestimonialModel>>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<BlogPostModel>>> getBlogPosts() async {
    try {
      if (_cachedBlogPosts != null) {
        return Success<List<BlogPostModel>>(_cachedBlogPosts!);
      }
      final List<BlogPostModel> list = await _localDataSource.getBlogPosts();
      _cachedBlogPosts = list;
      return Success<List<BlogPostModel>>(list);
    } catch (e) {
      return FailureResult<List<BlogPostModel>>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<BlogPostModel>> getBlogPostBySlug(String slug) async {
    try {
      final Result<List<BlogPostModel>> postsResult = await getBlogPosts();
      return switch (postsResult) {
        Success(:final data) => () {
            final BlogPostModel post = data.firstWhere(
              (BlogPostModel p) => p.slug.toLowerCase() == slug.toLowerCase(),
              orElse: () => throw const CacheFailure('Blog post not found'),
            );
            return Success<BlogPostModel>(post);
          }(),
        FailureResult(:final failure) => FailureResult<BlogPostModel>(failure),
      };
    } catch (e) {
      return FailureResult<BlogPostModel>(CacheFailure(e.toString()));
    }
  }
}
