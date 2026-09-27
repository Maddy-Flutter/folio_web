import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/presentation/admin/viewmodels/admin_auth_viewmodel.dart';
import 'package:follio/presentation/widgets/nav/theme_toggle_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveUtils.isDesktop(context);
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String currentPath = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: colors.navBackground,
              elevation: 0.0,
              title: Row(
                children: <Widget>[
                  Text(
                    'Folio',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Admin',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              actions: const <Widget>[
                ThemeToggleButton(),
                SizedBox(width: DesignTokens.space12),
              ],
            )
          : null,
      drawer: !isDesktop
          ? Drawer(
              backgroundColor: colorScheme.surface,
              child: SafeArea(
                child: _buildSidebarContent(
                  context,
                  colors,
                  colorScheme,
                  textTheme,
                  currentPath,
                ),
              ),
            )
          : null,
      bottomNavigationBar: !isDesktop
          ? NavigationBar(
              backgroundColor: colors.navBackground,
              selectedIndex: _getSelectedIndex(currentPath),
              onDestinationSelected: (int index) {
                _navigateToIndex(context, index);
              },
              destinations: const <NavigationDestination>[
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline_rounded),
                  selectedIcon: Icon(Icons.mail_rounded),
                  label: 'Messages',
                ),
                NavigationDestination(
                  icon: Icon(Icons.badge_outlined),
                  selectedIcon: Icon(Icons.badge_rounded),
                  label: 'Profile',
                ),
              ],
            )
          : null,
      body: Row(
        children: <Widget>[
          if (isDesktop)
            Container(
              width: 260.0,
              decoration: BoxDecoration(
                color: colors.cardBackground,
                border: Border(
                  right: BorderSide(color: colors.navBorder),
                ),
              ),
              child: _buildSidebarContent(
                context,
                colors,
                colorScheme,
                textTheme,
                currentPath,
              ),
            ),
          Expanded(
            child: SelectionArea(
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String path) {
    if (path.startsWith('/admin/messages')) return 1;
    if (path.startsWith('/admin/profile-update')) return 2;
    return 0;
  }

  void _navigateToIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/admin/dashboard');
      case 1:
        context.go('/admin/messages');
      case 2:
        context.go('/admin/profile-update');
    }
  }

  Widget _buildSidebarContent(
    BuildContext context,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
    String currentPath,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.space16,
            vertical: DesignTokens.space24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Folio',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const ThemeToggleButton(),
            ],
          ),
        ),
        const Divider(height: 1.0),
        const SizedBox(height: DesignTokens.space12),
        _SidebarNavItem(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard_rounded,
          label: 'Dashboard',
          isSelected: currentPath == '/admin/dashboard',
          onTap: () => context.go('/admin/dashboard'),
        ),
        _SidebarNavItem(
          icon: Icons.mail_outline_rounded,
          selectedIcon: Icons.mail_rounded,
          label: 'Messages',
          isSelected: currentPath.startsWith('/admin/messages'),
          onTap: () => context.go('/admin/messages'),
        ),
        _SidebarNavItem(
          icon: Icons.badge_outlined,
          selectedIcon: Icons.badge_rounded,
          label: 'Profile Update',
          isSelected: currentPath.startsWith('/admin/profile-update'),
          onTap: () => context.go('/admin/profile-update'),
        ),
        const Spacer(),
        const Divider(height: 1.0),
        Padding(
          padding: const EdgeInsets.all(DesignTokens.space16),
          child: ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: colorScheme.error,
              size: 20.0,
            ),
            title: Text(
              'Sign Out',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: DesignTokens.borderMd,
            ),
            onTap: () async {
              await context.read<AdminAuthViewModel>().logout();
              if (context.mounted) {
                context.go('/admin/login');
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space12,
        vertical: DesignTokens.space4,
      ),
      child: Material(
        color: isSelected ? colors.activeTagBackground : Colors.transparent,
        borderRadius: DesignTokens.borderMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignTokens.borderMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space16,
              vertical: DesignTokens.space12,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 20.0,
                  color: isSelected ? colors.accent : colors.textMuted,
                ),
                const SizedBox(width: DesignTokens.space14),
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isSelected ? colors.accent : colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
