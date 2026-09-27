abstract final class AppStrings {
  // Navigation
  static const String logoFirst = 'eli';
  static const String logoAccent = 'ott';
  static const String navServices = 'Services';
  static const String navWork = 'Work';
  static const String navAbout = 'About';
  static const String navReviews = 'Reviews';
  static const String navBlog = 'Blog';
  static const String navContact = 'Contact';
  static const String navHireMe = 'Hire me';
  static const String toggleLightMode = 'Light mode';
  static const String toggleDarkMode = 'Dark mode';
  static const String toggleMenu = 'Toggle menu';

  // Hero
  static const String heroAvailableBadge = 'Available for work';
  static const String heroGreeting = "Hi, I'm ";
  static const String heroName = 'Eliott';
  static const String heroSubtitlePrefix = 'Freelance ';
  static const String heroSubtitleHighlight = 'UI/UX Designer & Frontend Developer';
  static const String heroSubtitleSuffix =
      '. I design and build digital products that people love to use — fast, clean, and accessible.';
  static const String heroCtaWork = 'View my work';
  static const String heroCtaContact = 'Get in touch';
  static const String heroOpenToProjects = 'Open to projects';

  static const String statProjectsDoneVal = '34+';
  static const String statProjectsDoneLabel = 'Projects done';
  static const String statHappyClientsVal = '21+';
  static const String statHappyClientsLabel = 'Happy clients';
  static const String statExperienceVal = '5y';
  static const String statExperienceLabel = 'Experience';

  // Services
  static const String servicesCategory = 'What I do';
  static const String servicesTitle = 'Services';

  // Work
  static const String workCategory = 'Portfolio';
  static const String workTitle = 'Selected work';
  static const String workAllLink = 'All projects →';
  static const String workViewCaseStudy = 'View case study';

  // About
  static const String aboutCategory = 'About me';
  static const String aboutTitle = 'A bit about who I am';
  static const String aboutPara1 =
      "I'm Eliott, a freelance designer and frontend developer based in Paris with 5 years of experience shipping digital products for startups, agencies, and scale-ups across Europe. I thrive at the intersection of great design and clean code.";
  static const String aboutPara2 =
      "I believe great interfaces are invisible — they get out of the user's way. My work is fast, accessible and built to last. When I'm not coding, you'll find me hiking or hunting for a good espresso.";
  static const String aboutStackTitle = 'Stack & tools';
  static const List<String> aboutTools = [
    'Tailwind CSS',
    'Alpine.js',
    'Figma',
    'HTML / CSS',
    'JavaScript',
    'Symfony',
    'Framer',
    'Webflow',
  ];

  // Testimonials
  static const String reviewsCategory = 'Social proof';
  static const String reviewsTitle = 'What clients say';

  // Blog
  static const String blogCategory = 'Thoughts';
  static const String blogTitle = 'From the blog';
  static const String blogAllLink = 'All articles →';
  static const String blogReadMore = 'Read more →';

  // Contact
  static const String contactCategory = 'Get in touch';
  static const String contactTitle = "Let's work together";
  static const String contactIntro =
      "I'm open to UI/UX and frontend missions, short or long-term. Landing page, full product redesign, or just a second pair of eyes — let's talk.";
  static const String formNameLabel = 'Name';
  static const String formNamePlaceholder = 'Jane Smith';
  static const String formEmailLabel = 'Email';
  static const String formEmailPlaceholder = 'jane@company.com';
  static const String formSubjectLabel = 'Subject (Optional)';
  static const String formSubjectPlaceholder = 'Project inquiry';
  static const String formMessageLabel = 'Message';
  static const String formMessagePlaceholder = 'Tell me about your project...';
  static const String formSubmitButton = 'Send message →';
  static const String formSubmitting = 'Sending message...';

  // Contact Form Feedback & Validation
  static const String valNameRequired = 'Please enter your name (2–60 characters).';
  static const String valEmailInvalid = 'Please provide a valid email address.';
  static const String valSubjectTooLong = 'Subject cannot exceed 120 characters.';
  static const String valMessageRequired = 'Message must be between 10 and 2000 characters.';
  static const String rateLimitError = 'Please wait 60 seconds before submitting another inquiry.';
  static const String networkError = 'Network connection failed. Please check your internet and try again.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String genericError = 'Unable to send message right now. Please email hello@eliott.dev directly.';

  // Contact Success Panel
  static const String successTitle = 'Message received!';
  static const String successMessage =
      'Thank you for reaching out. I have received your message and will get back to you within 24–48 hours.';
  static const String successResetButton = 'Send another message';

  // Footer
  static const String footerCopyright = '© Eliott. All rights reserved.';
  static const String footerDevelopedBy = 'Developed by Laurent Begey • Distributed by ThemeWagon';
  static const String footerBuiltWith = 'Built natively in Flutter Web';

  // Projects View
  static const String projectsPageTitle = 'All Projects';
  static const String projectsPageSubtitle =
      'A complete look at my work across UI/UX design, frontend development and landing pages.';
  static const String filterAll = 'All';
  static const String filterSaaS = 'SaaS';
  static const String filterFintech = 'Fintech';
  static const String filterAgency = 'Agency';
  static const String filterMobile = 'Mobile';
  static const String filterEcommerce = 'E-Commerce';
  static const String noProjectsFound = 'No projects in this category yet.';

  // Case Study View
  static const String backToProjects = 'Back to projects';
  static const String clientLabel = 'Client';
  static const String roleLabel = 'Role';
  static const String timelineLabel = 'Timeline';
  static const String deliverablesLabel = 'Deliverables';
  static const String overviewHeading = 'Overview & Context';
  static const String challengeHeading = 'The Core Challenge';
  static const String solutionHeading = 'Strategy & Solution';
  static const String keyMetricsHeading = 'Key Results & Metrics';
  static const String nextCaseStudy = 'Next Case Study →';

  // Blog View
  static const String blogPageTitle = 'The Blog';
  static const String blogPageSubtitle =
      'Thoughts on UI/UX design, frontend development, and the realities of full-time freelancing. No fluff.';
  static const String filterDesign = 'Design';
  static const String filterDev = 'Dev';
  static const String filterFreelance = 'Freelance';
  static const String backToArticles = 'Back to articles';

  // Not Found View
  static const String notFoundTitle = '404';
  static const String notFoundSubtitle = 'Page not found';
  static const String notFoundMessage = "The page you're looking for doesn't exist or has been moved.";
  static const String notFoundHomeButton = 'Return to Home';
}
