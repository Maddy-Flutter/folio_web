import 'package:flutter/material.dart';
import 'package:follio/core/services/analytics_service.dart';
import 'package:follio/core/utils/scroll_controller_registry.dart';
import 'package:follio/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:follio/presentation/widgets/about/about_section.dart';
import 'package:follio/presentation/widgets/blog/blog_section.dart';
import 'package:follio/presentation/widgets/contact/contact_section.dart';
import 'package:follio/presentation/widgets/footer/app_footer.dart';
import 'package:follio/presentation/widgets/hero/hero_section.dart';
import 'package:follio/presentation/widgets/nav/sticky_navbar.dart';
import 'package:follio/presentation/widgets/services/services_section.dart';
import 'package:follio/presentation/widgets/testimonials/testimonials_section.dart';
import 'package:follio/presentation/widgets/work/selected_work_section.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<AnalyticsService>().trackVisit();
        } catch (_) {
          // Graceful fallback if AnalyticsService is not in widget tree
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final NavigationViewModel navVm = context.read<NavigationViewModel>();

    // Update sticky glassmorphism trigger
    navVm.setScrolled(offset > 20);

    // Scroll spy for active section highlight
    final ScrollSectionRegistry registry = ScrollSectionRegistry.instance;
    final List<String> sections = <String>[
      'contact',
      'blog',
      'reviews',
      'about',
      'work',
      'services',
      'hero',
    ];

    for (final String id in sections) {
      final GlobalKey? key = registry.getKey(id);
      final BuildContext? ctx = key?.currentContext;
      if (ctx != null) {
        final RenderBox? box = ctx.findRenderObject() as RenderBox?;
        if (box != null) {
          final Offset pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= 160) {
            navVm.setActiveSection(id);
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollSectionRegistry registry = ScrollSectionRegistry.instance;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Main Scrollable Content
          SelectionArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 64.0), // Spacer for sticky nav
                  Container(
                    key: registry.getKey('hero'),
                    child: const HeroSection(),
                  ),
                  Container(
                    key: registry.getKey('services'),
                    child: const ServicesSection(),
                  ),
                  Container(
                    key: registry.getKey('work'),
                    child: const SelectedWorkSection(),
                  ),
                  Container(
                    key: registry.getKey('about'),
                    child: const AboutSection(),
                  ),
                  Container(
                    key: registry.getKey('reviews'),
                    child: const TestimonialsSection(),
                  ),
                  Container(
                    key: registry.getKey('blog'),
                    child: const BlogSection(),
                  ),
                  Container(
                    key: registry.getKey('contact'),
                    child: const ContactSection(),
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          ),

          // Sticky Top Navigation
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StickyNavbar(),
          ),
        ],
      ),
    );
  }
}
