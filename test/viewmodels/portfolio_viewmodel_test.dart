import 'package:flutter_test/flutter_test.dart';
import 'package:follio/core/errors/failures.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_repositories.dart';

void main() {
  late MockPortfolioRepository mockPortfolioRepo;
  late PortfolioViewModel viewModel;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockPortfolioRepo = MockPortfolioRepository();

    when(() => mockPortfolioRepo.getServices())
        .thenAnswer((_) async => Success<List<ServiceModel>>(testServices));
    when(() => mockPortfolioRepo.getProjects())
        .thenAnswer((_) async => Success<List<ProjectModel>>(testProjects));
    when(() => mockPortfolioRepo.getTestimonials())
        .thenAnswer((_) async => Success<List<TestimonialModel>>(testTestimonials));
    when(() => mockPortfolioRepo.getBlogPosts())
        .thenAnswer((_) async => Success<List<BlogPostModel>>(testBlogPosts));

    viewModel = PortfolioViewModel(portfolioRepository: mockPortfolioRepo);
  });

  group('PortfolioViewModel Tests', () {
    test('Initial loading populates services, projects, testimonials, and blog posts', () async {
      await viewModel.init();

      expect(viewModel.viewState, ViewState.success);
      expect(viewModel.services.length, 3);
      expect(viewModel.projects.length, 2);
      expect(viewModel.testimonials.length, 2);
      expect(viewModel.blogPosts.length, 1);
    });

    test('Filters projects by category correctly', () async {
      await viewModel.init();

      viewModel.setProjectFilter('saas');
      expect(viewModel.filteredProjects.length, 1);
      expect(viewModel.filteredProjects.first.category, 'saas');

      viewModel.setProjectFilter('all');
      expect(viewModel.filteredProjects.length, 2);
    });

    test('Filters blog posts by category correctly', () async {
      await viewModel.init();

      viewModel.setBlogFilter('design');
      expect(viewModel.filteredBlogPosts.length, 1);

      viewModel.setBlogFilter('dev');
      expect(viewModel.filteredBlogPosts, isEmpty);
    });

    test('Loads project by slug successfully', () async {
      when(() => mockPortfolioRepo.getProjectBySlug('novu-saas-dashboard'))
          .thenAnswer((_) async => Success<ProjectModel>(testProjects.first));

      await viewModel.loadProjectBySlug('novu-saas-dashboard');

      expect(viewModel.detailState, ViewState.success);
      expect(viewModel.selectedProject?.title, 'Novu — SaaS Dashboard');
    });

    test('Handles project slug error', () async {
      when(() => mockPortfolioRepo.getProjectBySlug('unknown-slug'))
          .thenAnswer((_) async => const FailureResult<ProjectModel>(CacheFailure('Not found')));

      await viewModel.loadProjectBySlug('unknown-slug');

      expect(viewModel.detailState, ViewState.error);
      expect(viewModel.errorMessage, 'Not found');
    });

    test('Loads blog post by slug successfully', () async {
      when(() => mockPortfolioRepo.getBlogPostBySlug('why-i-ditched-heavy-css-frameworks-for-tailwind'))
          .thenAnswer((_) async => Success<BlogPostModel>(testBlogPosts.first));

      await viewModel.loadBlogPostBySlug('why-i-ditched-heavy-css-frameworks-for-tailwind');

      expect(viewModel.detailState, ViewState.success);
      expect(viewModel.selectedBlogPost?.slug, 'why-i-ditched-heavy-css-frameworks-for-tailwind');
    });
  });
}
