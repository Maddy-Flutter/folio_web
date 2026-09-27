import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_messages_viewmodel.dart';
import 'package:follio/presentation/admin/views/admin_message_detail_dialog.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:provider/provider.dart';

class AdminMessagesView extends StatefulWidget {
  const AdminMessagesView({super.key});

  @override
  State<AdminMessagesView> createState() => _AdminMessagesViewState();
}

class _AdminMessagesViewState extends State<AdminMessagesView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminMessagesViewModel vm = context.watch<AdminMessagesViewModel>();
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: ResponsiveContainer(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.horizontalPadding(context),
          vertical: DesignTokens.space32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header
            Text(
              'Inquiries',
              style: textTheme.labelSmall?.copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: DesignTokens.space4),
            Text(
              'Received Messages',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: DesignTokens.space24),

            // Filter & Search Toolbar
            Container(
              padding: const EdgeInsets.all(DesignTokens.space16),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: DesignTokens.borderLg,
                border: Border.all(color: colors.navBorder),
              ),
              child: Wrap(
                spacing: DesignTokens.space16,
                runSpacing: DesignTokens.space12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  // Search text field
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: vm.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by name, email, subject...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20.0),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18.0),
                                onPressed: () {
                                  _searchController.clear();
                                  vm.setSearchQuery('');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space14,
                          vertical: DesignTokens.space10,
                        ),
                      ),
                    ),
                  ),

                  // Unread only filter chip
                  FilterChip(
                    selected: vm.unreadOnly,
                    onSelected: (_) => vm.toggleUnreadOnly(),
                    label: const Text('Unread only'),
                    avatar: Icon(
                      vm.unreadOnly
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16.0,
                      color: vm.unreadOnly ? colors.accent : colors.textMuted,
                    ),
                    selectedColor: colors.activeTagBackground,
                    shape: const RoundedRectangleBorder(
                      borderRadius: DesignTokens.borderPill,
                    ),
                  ),

                  if (vm.searchQuery.isNotEmpty || vm.unreadOnly)
                    TextButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        vm.clearFilters();
                      },
                      icon: const Icon(Icons.restart_alt_rounded, size: 16.0),
                      label: const Text('Reset filters'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.space24),

            // Messages Container
            Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: DesignTokens.borderXl,
                border: Border.all(color: colors.navBorder),
              ),
              child: vm.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(DesignTokens.space48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : vm.messages.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(DesignTokens.space48),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 48.0,
                                  color: colors.textSubtle,
                                ),
                                const SizedBox(height: DesignTokens.space12),
                                Text(
                                  'No messages match your filter.',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.messages.length,
                          separatorBuilder: (_, _) => const Divider(height: 1.0),
                          itemBuilder: (BuildContext context, int index) {
                            final ContactMessageModel msg = vm.messages[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.space20,
                                vertical: DesignTokens.space10,
                              ),
                              leading: Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: msg.isRead
                                      ? Colors.transparent
                                      : colors.accent,
                                  border: Border.all(
                                    color: msg.isRead
                                        ? colors.tagBorder
                                        : colors.accent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    msg.name,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: msg.isRead
                                          ? FontWeight.w500
                                          : FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: DesignTokens.space8),
                                  Text(
                                    '•  ${msg.email}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.textMuted,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatTimestamp(msg.receivedAt),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colors.textSubtle,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: DesignTokens.space4),
                                child: Text(
                                  '${msg.subject} — ${msg.message}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: msg.isRead
                                        ? colors.textMuted
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.chevron_right_rounded),
                                onPressed: () {
                                  vm.selectMessage(msg);
                                  showDialog<void>(
                                    context: context,
                                    builder: (_) => AdminMessageDetailDialog(message: msg),
                                  );
                                },
                              ),
                              onTap: () {
                                vm.selectMessage(msg);
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => AdminMessageDetailDialog(message: msg),
                                );
                              },
                            );
                          },
                        ),
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
