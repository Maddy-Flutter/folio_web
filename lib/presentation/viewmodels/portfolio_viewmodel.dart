import 'package:flutter/material.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/domain/repositories/portfolio_repository.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';

final class PortfolioViewModel extends ChangeNotifier {
  PortfolioViewModel({
    required PortfolioRepository portfolioRepository,
    ProfileContentRepository? profileContentRepository,
  })  : _portfolioRepository = portfolioRepository,
        _profileContentRepository = profileContentRepository {
    init();
  }

  final PortfolioRepository _portfolioRepository;
  final ProfileContentRepository? _profileContentRepository;

  ViewState _viewState = ViewState.idle;
  String _errorMessage = '';
  bool _isDisposed = false;

  ProfileDraft? _profileContent;
  ProfileDraft? get profileContent => _profileContent;

  List<ServiceModel> _services = <ServiceModel>[];
  List<ProjectModel> _projects = <ProjectModel>[];
  List<TestimonialModel> _testimonials = <TestimonialModel>[];
  List<BlogPostModel> _blogPosts = <BlogPostModel>[];

  // Filters
  String _projectFilter = 'all';
  String _blogFilter = 'all';

  // Selected item states
  ViewState _detailState = ViewState.idle;
  ProjectModel? _selectedProject;
  BlogPostModel? _selectedBlogPost;

  ViewState get viewState => _viewState;
  ViewState get detailState => _detailState;
  String get errorMessage => _errorMessage;

  List<ServiceModel> get services => _services;
  List<ProjectModel> get projects => _projects;
  List<TestimonialModel> get testimonials => _testimonials;
  List<BlogPostModel> get blogPosts => _blogPosts;

  String get projectFilter => _projectFilter;
  String get blogFilter => _blogFilter;

  ProjectModel? get selectedProject => _selectedProject;
  BlogPostModel? get selectedBlogPost => _selectedBlogPost;

  List<ProjectModel> get filteredProjects {
    if (_projectFilter == 'all') return _projects;
    return _projects
        .where((ProjectModel p) => p.category.toLowerCase() == _projectFilter.toLowerCase())
        .toList();
  }

  List<BlogPostModel> get filteredBlogPosts {
    if (_blogFilter == 'all') return _blogPosts;
    return _blogPosts
        .where((BlogPostModel b) => b.category.toLowerCase() == _blogFilter.toLowerCase())
        .toList();
  }

  Future<void> init() async {
    _viewState = ViewState.loading;
    _errorMessage = '';
    _safeNotify();

    final List<Result<dynamic>> results = await Future.wait(<Future<Result<dynamic>>>[
      _portfolioRepository.getServices(),
      _portfolioRepository.getProjects(),
      _portfolioRepository.getTestimonials(),
      _portfolioRepository.getBlogPosts(),
    ]);

    final Result<dynamic> servicesRes = results[0];
    final Result<dynamic> projectsRes = results[1];
    final Result<dynamic> testimonialsRes = results[2];
    final Result<dynamic> blogPostsRes = results[3];

    if (servicesRes.isSuccess &&
        projectsRes.isSuccess &&
        testimonialsRes.isSuccess &&
        blogPostsRes.isSuccess) {
      _services = (servicesRes as Success<List<ServiceModel>>).data;
      _projects = (projectsRes as Success<List<ProjectModel>>).data;
      _testimonials = (testimonialsRes as Success<List<TestimonialModel>>).data;
      _blogPosts = (blogPostsRes as Success<List<BlogPostModel>>).data;
      _viewState = ViewState.success;
    } else {
      _errorMessage = 'Failed to load portfolio content.';
      _viewState = ViewState.error;
    }

    if (_profileContentRepository != null) {
      final Result<ProfileDraft> profileRes =
          await _profileContentRepository.getActiveProfile();
      if (profileRes.isSuccess) {
        _profileContent = (profileRes as Success<ProfileDraft>).data;
      }
    }

    _safeNotify();
  }

  void setProjectFilter(String filter) {
    if (_projectFilter == filter) return;
    _projectFilter = filter;
    _safeNotify();
  }

  void setBlogFilter(String filter) {
    if (_blogFilter == filter) return;
    _blogFilter = filter;
    _safeNotify();
  }

  Future<void> loadProjectBySlug(String slug) async {
    _detailState = ViewState.loading;
    _selectedProject = null;
    _errorMessage = '';
    _safeNotify();

    final Result<ProjectModel> result = await _portfolioRepository.getProjectBySlug(slug);
    switch (result) {
      case Success(:final data):
        _selectedProject = data;
        _detailState = ViewState.success;
      case FailureResult(:final failure):
        _errorMessage = failure.message;
        _detailState = ViewState.error;
    }
    _safeNotify();
  }

  Future<void> loadBlogPostBySlug(String slug) async {
    _detailState = ViewState.loading;
    _selectedBlogPost = null;
    _errorMessage = '';
    _safeNotify();

    final Result<BlogPostModel> result = await _portfolioRepository.getBlogPostBySlug(slug);
    switch (result) {
      case Success(:final data):
        _selectedBlogPost = data;
        _detailState = ViewState.success;
      case FailureResult(:final failure):
        _errorMessage = failure.message;
        _detailState = ViewState.error;
    }
    _safeNotify();
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
