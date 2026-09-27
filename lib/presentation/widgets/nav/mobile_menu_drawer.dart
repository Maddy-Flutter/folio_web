import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/presentation/viewmodels/navigation_viewmodel.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MobileMenuDrawer extends StatelessWidget {
  const MobileMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = context.select<NavigationViewModel, bool>(
      (NavigationViewModel vm) => vm.isMobileMenuOpen,
    );

    if (!isOpen) return const SizedBox.shrink();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space24,
        vertical: DesignTokens.space20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _MobileNavItem(
            label: AppStrings.navServices,
            onTap: () => _handleNav(context, 'services'),
          ),
          _MobileNavItem(
            label: AppStrings.navWork,
            onTap: () => _handleNav(context, 'work'),
          ),
          _MobileNavItem(
            label: AppStrings.navAbout,
            onTap: () => _handleNav(context, 'about'),
          ),
          _MobileNavItem(
            label: AppStrings.navReviews,
            onTap: () => _handleNav(context, 'reviews'),
          ),
          _MobileNavItem(
            label: AppStrings.navBlog,
            onTap: () => _handleNav(context, 'blog'),
          ),
          _MobileNavItem(
            label: AppStrings.navContact,
            onTap: () => _handleNav(context, 'contact'),
          ),
          const SizedBox(height: DesignTokens.space12),
          const Divider(),
          const SizedBox(height: DesignTokens.space12),
          SizedBox(
            width: double.infinity,
            child: ShimmerButton(
              label: '${AppStrings.navHireMe} →',
              onPressed: () => _handleNav(context, 'contact'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNav(BuildContext context, String sectionId) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location != '/' && location != '') {
      context.go('/#$sectionId');
    } else {
      context.read<NavigationViewModel>().navigateToSection(sectionId);
    }
  }
}

class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.space10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
