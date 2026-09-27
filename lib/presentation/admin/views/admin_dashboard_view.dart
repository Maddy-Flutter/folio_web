import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/analytics_summary_model.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardViewModel vm = context.watch<AdminDashboardViewModel>();
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    return SingleChildScrollView(
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.horizontalPadding(context),
          vertical: DesignTokens.space32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Overview',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.space4),
                    Text(
                      'Admin Dashboard',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                ShimmerButton(
                  label: 'Update Profile',
                  icon: Icon(
                    Icons.upload_file_rounded,
                    size: 16.0,
                    color: colorScheme.onPrimary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space20,
                    vertical: DesignTokens.space12,
                  ),
                  onPressed: () => context.go('/admin/profile-update'),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.space32),

            if (vm.isLoading) ...<Widget>[
              _buildSkeleton(context, colors, isDesktop),
            ] else if (vm.errorMessage.isNotEmpty) ...<Widget>[
              _buildError(context, vm, colorScheme, textTheme),
            ] else ...<Widget>[
              // Top Stat Cards
              _buildStatCards(context, vm.summary, colors, colorScheme, textTheme, isDesktop),
              const SizedBox(height: DesignTokens.space40),

              // Recent Messages Section
              _buildRecentMessagesSection(
                context,
                vm.recentMessages,
                colors,
                colorScheme,
                textTheme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(
    BuildContext context,
    AnalyticsSummaryModel summary,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDesktop,
  ) {
    final Widget messagesCard = _StatCard(
      title: 'Messages Received',
      count: summary.totalMessages.toString(),
      trend: summary.unreadMessages > 0
          ? '${summary.unreadMessages} unread inquiry'
          : 'All caught up',
      icon: Icons.mail_outline_rounded,
      accentColor: colors.accent,
      onTap: () => context.go('/admin/messages'),
    );

    final Widget visitorsCard = _StatCard(
      title: 'Site Visitors',
      count: summary.totalVisitors.toString(),
      trend: '+${summary.visitorsThisWeek} this week',
      icon: Icons.people_outline_rounded,
      accentColor: colors.statusAvailable,
    );

    if (isDesktop) {
      return Row(
        children: <Widget>[
          Expanded(child: messagesCard),
          const SizedBox(width: DesignTokens.space24),
          Expanded(child: visitorsCard),
        ],
      );
    }

    return Column(
      children: <Widget>[
        messagesCard,
        const SizedBox(height: DesignTokens.space16),
        visitorsCard,
      ],
    );
  }

  Widget _buildRecentMessagesSection(
    BuildContext context,
    List<ContactMessageModel> recentMessages,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: DesignTokens.borderXl,
        border: Border.all(color: colors.navBorder),
      ),
      padding: const EdgeInsets.all(DesignTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Recent Activity',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton.icon(
                onPressed: () => context.go('/admin/messages'),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16.0),
                label: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space16),
          if (recentMessages.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: DesignTokens.space32),
              child: Center(
                child: Text(
                  'No messages received yet.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentMessages.length,
              separatorBuilder: (_, _) => const Divider(height: 1.0),
              itemBuilder: (BuildContext context, int index) {
                final ContactMessageModel msg = recentMessages[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space8,
                    vertical: DesignTokens.space6,
                  ),
                  leading: Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: msg.isRead
                          ? colorScheme.surfaceContainerHighest
                          : colors.activeTagBackground,
                      borderRadius: DesignTokens.borderMd,
                    ),
                    child: Icon(
                      msg.isRead ? Icons.mark_email_read_rounded : Icons.mark_email_unread_rounded,
                      size: 20.0,
                      color: msg.isRead ? colors.textMuted : colors.accent,
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          msg.name,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: msg.isRead ? FontWeight.w500 : FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTimestamp(msg.receivedAt),
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    msg.subject,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => context.go('/admin/messages'),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context, PortfolioColors colors, bool isDesktop) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 140.0,
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: DesignTokens.borderXl,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.space24),
            Expanded(
              child: Container(
                height: 140.0,
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: DesignTokens.borderXl,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.space32),
        Container(
          height: 280.0,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: DesignTokens.borderXl,
          ),
        ),
      ],
    );
  }

  Widget _buildError(
    BuildContext context,
    AdminDashboardViewModel vm,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DesignTokens.space48),
        child: Column(
          children: <Widget>[
            Icon(Icons.error_outline_rounded, size: 40.0, color: colorScheme.error),
            const SizedBox(height: DesignTokens.space12),
            Text(vm.errorMessage, style: textTheme.bodyMedium),
            const SizedBox(height: DesignTokens.space16),
            FilledButton.icon(
              onPressed: vm.loadDashboard,
              icon: const Icon(Icons.refresh_rounded, size: 16.0),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final Duration diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.count,
    required this.trend,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  final String title;
  final String count;
  final String trend;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.cardBackground,
      borderRadius: DesignTokens.borderXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignTokens.borderXl,
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.space24),
          decoration: BoxDecoration(
            borderRadius: DesignTokens.borderXl,
            border: Border.all(color: colors.navBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space8),
                  Text(
                    count,
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.space4),
                  Row(
                    children: <Widget>[
                      Icon(Icons.trending_up_rounded, size: 14.0, color: accentColor),
                      const SizedBox(width: DesignTokens.space4),
                      Text(
                        trend,
                        style: textTheme.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
