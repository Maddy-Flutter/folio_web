import 'package:follio/core/result/result.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';

abstract interface class PortfolioRepository {
  Future<Result<List<ServiceModel>>> getServices();
  Future<Result<List<ProjectModel>>> getProjects();
  Future<Result<ProjectModel>> getProjectBySlug(String slug);
  Future<Result<List<TestimonialModel>>> getTestimonials();
  Future<Result<List<BlogPostModel>>> getBlogPosts();
  Future<Result<BlogPostModel>> getBlogPostBySlug(String slug);
}
