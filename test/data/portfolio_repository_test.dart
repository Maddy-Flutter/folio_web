import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/data/repositories/portfolio_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockPortfolioLocalDataSource mockLocalDataSource;
  late PortfolioRepositoryImpl repository;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockLocalDataSource = MockPortfolioLocalDataSource();
    repository = PortfolioRepositoryImpl(localDataSource: mockLocalDataSource);

    when(() => mockLocalDataSource.getServices())
        .thenAnswer((_) async => testServices);
    when(() => mockLocalDataSource.getProjects())
        .thenAnswer((_) async => testProjects);
    when(() => mockLocalDataSource.getTestimonials())
        .thenAnswer((_) async => testTestimonials);
    when(() => mockLocalDataSource.getBlogPosts())
        .thenAnswer((_) async => testBlogPosts);
  });

  group('PortfolioRepositoryImpl Tests', () {
    test('getServices returns data from dataSource and caches on second call', () async {
      final Result<List<ServiceModel>> firstResult = await repository.getServices();

      expect(firstResult.isSuccess, isTrue);
      expect(firstResult.valueOrNull?.length, equals(testServices.length));
      verify(() => mockLocalDataSource.getServices()).called(1);

      // Second call should return cached data without invoking localDataSource again
      final Result<List<ServiceModel>> secondResult = await repository.getServices();
      expect(secondResult.isSuccess, isTrue);
      expect(secondResult.valueOrNull?.first.title, equals(testServices.first.title));
      verifyNever(() => mockLocalDataSource.getServices());
    });

    test('getServices returns CacheFailure when dataSource throws', () async {
      when(() => mockLocalDataSource.getServices())
          .thenThrow(Exception('Disk read failure'));

      final Result<List<ServiceModel>> result = await repository.getServices();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('getProjects returns data from dataSource and caches on second call', () async {
      final Result<List<ProjectModel>> firstResult = await repository.getProjects();

      expect(firstResult.isSuccess, isTrue);
      expect(firstResult.valueOrNull?.length, equals(testProjects.length));
      verify(() => mockLocalDataSource.getProjects()).called(1);

      final Result<List<ProjectModel>> secondResult = await repository.getProjects();
      expect(secondResult.isSuccess, isTrue);
      verifyNever(() => mockLocalDataSource.getProjects());
    });

    test('getProjects returns CacheFailure when dataSource throws', () async {
      when(() => mockLocalDataSource.getProjects())
          .thenThrow(Exception('JSON parse error'));

      final Result<List<ProjectModel>> result = await repository.getProjects();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('getProjectBySlug finds project with matching slug case-insensitively', () async {
      final Result<ProjectModel> result =
          await repository.getProjectBySlug('NOVU-SAAS-DASHBOARD');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.slug, equals('novu-saas-dashboard'));
      expect(result.valueOrNull?.title, equals('Novu — SaaS Dashboard'));
    });

    test('getProjectBySlug returns FailureResult when project is not found', () async {
      final Result<ProjectModel> result =
          await repository.getProjectBySlug('non-existent-project');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('getTestimonials returns data from dataSource and caches on second call', () async {
      final Result<List<TestimonialModel>> firstResult = await repository.getTestimonials();

      expect(firstResult.isSuccess, isTrue);
      expect(firstResult.valueOrNull?.length, equals(testTestimonials.length));
      verify(() => mockLocalDataSource.getTestimonials()).called(1);

      final Result<List<TestimonialModel>> secondResult = await repository.getTestimonials();
      expect(secondResult.isSuccess, isTrue);
      verifyNever(() => mockLocalDataSource.getTestimonials());
    });

    test('getTestimonials returns CacheFailure when dataSource throws', () async {
      when(() => mockLocalDataSource.getTestimonials())
          .thenThrow(Exception('Failed to load testimonials'));

      final Result<List<TestimonialModel>> result = await repository.getTestimonials();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('getBlogPosts returns data from dataSource and caches on second call', () async {
      final Result<List<BlogPostModel>> firstResult = await repository.getBlogPosts();

      expect(firstResult.isSuccess, isTrue);
      expect(firstResult.valueOrNull?.length, equals(testBlogPosts.length));
      verify(() => mockLocalDataSource.getBlogPosts()).called(1);

      final Result<List<BlogPostModel>> secondResult = await repository.getBlogPosts();
      expect(secondResult.isSuccess, isTrue);
      verifyNever(() => mockLocalDataSource.getBlogPosts());
    });

    test('getBlogPosts returns CacheFailure when dataSource throws', () async {
      when(() => mockLocalDataSource.getBlogPosts())
          .thenThrow(Exception('Failed to load posts'));

      final Result<List<BlogPostModel>> result = await repository.getBlogPosts();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('getBlogPostBySlug finds post with matching slug case-insensitively', () async {
      final Result<BlogPostModel> result = await repository
          .getBlogPostBySlug('WHY-I-DITCHED-HEAVY-CSS-FRAMEWORKS-FOR-TAILWIND');

      expect(result.isSuccess, isTrue);
      expect(
        result.valueOrNull?.slug,
        equals('why-i-ditched-heavy-css-frameworks-for-tailwind'),
      );
      expect(
        result.valueOrNull?.title,
        equals('Why I ditched heavy CSS frameworks for Tailwind'),
      );
    });

    test('getBlogPostBySlug returns FailureResult when post is not found', () async {
      final Result<BlogPostModel> result =
          await repository.getBlogPostBySlug('non-existent-post');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });
  });
}
