import 'package:flutter/material.dart';
import 'package:follio/core/auth/auth_session.dart';
import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/result/result.dart';
import 'package:follio/data/datasources/contact_remote_data_source.dart';
import 'package:follio/data/datasources/portfolio_local_data_source.dart';
import 'package:follio/data/datasources/preferences_local_data_source.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/data/models/blog_post_model.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/data/models/contact_submission_dto.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/data/models/project_model.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/domain/repositories/analytics_repository.dart';
import 'package:follio/domain/repositories/auth_repository.dart';
import 'package:follio/domain/repositories/contact_repository.dart';
import 'package:follio/domain/repositories/messages_repository.dart';
import 'package:follio/domain/repositories/portfolio_repository.dart';
import 'package:follio/domain/repositories/profile_content_repository.dart';
import 'package:follio/domain/repositories/theme_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockPortfolioRepository extends Mock implements PortfolioRepository {}

class MockContactRepository extends Mock implements ContactRepository {}

class MockThemeRepository extends Mock implements ThemeRepository {}

class MockPortfolioLocalDataSource extends Mock implements PortfolioLocalDataSource {}

class MockContactRemoteDataSource extends Mock implements ContactRemoteDataSource {}

class MockPreferencesLocalDataSource extends Mock implements PreferencesLocalDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class MockMessagesRepository extends Mock implements MessagesRepository {}

class MockProfileContentRepository extends Mock implements ProfileContentRepository {}

class MockAuthStorage extends Mock implements AuthStorage {}

bool _fallbacksRegistered = false;

void registerTestFallbacks() {
  if (_fallbacksRegistered) return;
  _fallbacksRegistered = true;

  registerFallbackValue(ThemeMode.dark);
  registerFallbackValue(
    const ContactSubmissionDto(name: '', email: '', message: ''),
  );
  registerFallbackValue(
    const Success<List<ServiceModel>>(<ServiceModel>[]),
  );
  registerFallbackValue(
    const Success<List<ProjectModel>>(<ProjectModel>[]),
  );
  registerFallbackValue(
    const Success<List<TestimonialModel>>(<TestimonialModel>[]),
  );
  registerFallbackValue(
    const Success<List<BlogPostModel>>(<BlogPostModel>[]),
  );
  registerFallbackValue(
    AuthSession(
      token: 'test_token',
      username: 'admin',
      issuedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    ),
  );
  registerFallbackValue(ProfileDraft.initialDefault);
}

final List<ServiceModel> testServices = <ServiceModel>[
  const ServiceModel(
    id: 's1',
    iconKey: 'design',
    title: 'UI/UX Design',
    description: 'Design mock description',
    isHighlighted: false,
  ),
  const ServiceModel(
    id: 's2',
    iconKey: 'code',
    title: 'Frontend Dev',
    description: 'Frontend mock description',
    isHighlighted: true,
  ),
  const ServiceModel(
    id: 's3',
    iconKey: 'layout',
    title: 'Landing Pages',
    description: 'Landing pages mock description',
    isHighlighted: false,
  ),
];

final List<ProjectModel> testProjects = <ProjectModel>[
  const ProjectModel(
    id: 'p1',
    slug: 'novu-saas-dashboard',
    title: 'Novu — SaaS Dashboard',
    category: 'saas',
    categoryLabel: 'SaaS',
    tags: <String>['SaaS', 'Figma'],
    excerpt: 'Test project excerpt',
    fullDescription: 'Test full description',
    client: 'Novu Inc',
    role: 'Lead UI/UX',
    timeline: '8 weeks',
    deliverables: <String>['Figma Library'],
    coverImage: 'https://example.com/img1.jpg',
    isFeatured: true,
    year: '2024',
    stats: <ProjectStatModel>[
      ProjectStatModel(label: 'Conversion', value: '+28%'),
    ],
  ),
  const ProjectModel(
    id: 'p2',
    slug: 'finlo-fintech-app',
    title: 'Finlo — Fintech App',
    category: 'fintech',
    categoryLabel: 'Fintech',
    tags: <String>['Fintech'],
    excerpt: 'Finlo project excerpt',
    fullDescription: 'Finlo full description',
    client: 'Finlo Group',
    role: 'Product Designer',
    timeline: '5 weeks',
    deliverables: <String>['Landing page'],
    coverImage: 'https://example.com/img2.jpg',
    isFeatured: false,
    year: '2025',
    stats: <ProjectStatModel>[],
  ),
];

final List<TestimonialModel> testTestimonials = <TestimonialModel>[
  const TestimonialModel(
    id: 't1',
    name: 'Sarah Müller',
    role: 'CPO',
    company: 'Novu',
    avatarUrl: 'https://example.com/avatar1.jpg',
    rating: 5,
    quote: 'Exceptional work.',
  ),
  const TestimonialModel(
    id: 't2',
    name: 'Thomas Renault',
    role: 'Founder',
    company: 'Finlo',
    avatarUrl: 'https://example.com/avatar2.jpg',
    rating: 5,
    quote: 'Great collaboration.',
  ),
];

final List<BlogPostModel> testBlogPosts = <BlogPostModel>[
  const BlogPostModel(
    id: 'b1',
    slug: 'why-i-ditched-heavy-css-frameworks-for-tailwind',
    title: 'Why I ditched heavy CSS frameworks for Tailwind',
    category: 'Design',
    date: 'March 8, 2025',
    readTime: '7 min read',
    excerpt: 'Test blog excerpt',
    content: '### Test Heading\n\nTest paragraph content.',
    coverImage: 'https://example.com/blog1.jpg',
    isFeatured: true,
  ),
];

final List<ContactMessageModel> testMessages = <ContactMessageModel>[
  ContactMessageModel(
    id: 'msg_1',
    name: 'Alice Smith',
    email: 'alice@example.com',
    subject: 'Project Inquiry',
    message: 'Hello, looking for a design partner.',
    receivedAt: DateTime(2025, 1, 10, 14, 30),
  ),
  ContactMessageModel(
    id: 'msg_2',
    name: 'Bob Jones',
    email: 'bob@example.com',
    subject: 'Consulting',
    message: 'Are you available for a frontend audit?',
    receivedAt: DateTime(2025, 1, 9, 10, 15),
    isRead: true,
  ),
];

const AnalyticsSummaryModel testAnalyticsSummary = AnalyticsSummaryModel(
  totalVisitors: 1540,
  visitorsThisWeek: 320,
  totalMessages: 12,
  unreadMessages: 3,
);

