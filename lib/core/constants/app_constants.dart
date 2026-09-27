abstract final class AppConstants {
  static const String appTitle = 'Eliott — Freelance UI/UX Designer & Frontend Developer';
  static const String appAuthor = 'Eliott';
  static const String contactEmail = 'hello@eliott.dev';
  static const String linkedInUrl = 'https://linkedin.com/in/eliott-dev';
  static const String gitHubUrl = 'https://github.com/eliott-dev';

  // EmailJS configuration via --dart-define
  static const String emailJsServiceId = String.fromEnvironment('EMAILJS_SERVICE_ID');
  static const String emailJsTemplateId = String.fromEnvironment('EMAILJS_TEMPLATE_ID');
  static const String emailJsPublicKey = String.fromEnvironment('EMAILJS_PUBLIC_KEY');
  static const String emailJsAutoReplyTemplateId = String.fromEnvironment('EMAILJS_AUTOREPLY_TEMPLATE_ID');

  static const String emailJsEndpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  // Persistence keys
  static const String themePrefKey = 'portfolio_theme_mode';
  static const String lastSubmitPrefKey = 'portfolio_last_contact_submit_ms';

  // Constraints & Limits
  static const Duration contactTimeout = Duration(seconds: 15);
  static const Duration rateLimitCooldown = Duration(seconds: 60);

  // Asset paths
  static const String servicesJsonPath = 'assets/data/services.json';
  static const String projectsJsonPath = 'assets/data/projects.json';
  static const String testimonialsJsonPath = 'assets/data/testimonials.json';
  static const String postsJsonPath = 'assets/data/posts.json';
}
