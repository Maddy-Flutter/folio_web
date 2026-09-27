import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/data/models/contact_message_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_messages_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminMessageDetailDialog extends StatelessWidget {
  const AdminMessageDetailDialog({
    super.key,
    required this.message,
  });

  final ContactMessageModel message;

  Future<void> _launchEmail(String email, String subject) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: <String, String>{
        'subject': 'Re: $subject',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AdminMessagesViewModel vm = context.read<AdminMessagesViewModel>();

    return Dialog(
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(borderRadius: DesignTokens.border2Xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580.0),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.space32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Top row: Avatar + Sender info + Close
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 24.0,
                    backgroundColor: colors.accent.withValues(alpha: 0.15),
                    child: Text(
                      message.name.isNotEmpty ? message.name[0].toUpperCase() : '?',
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.space2),
                        InkWell(
                          onTap: () => _launchEmail(message.email, message.subject),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.mail_outline_rounded, size: 14.0, color: colors.accent),
                              const SizedBox(width: DesignTokens.space4),
                              Text(
                                message.email,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.accent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.space24),
              const Divider(height: 1.0),
              const SizedBox(height: DesignTokens.space20),

              // Subject
              Text(
                'Subject',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSubtle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DesignTokens.space4),
              Text(
                message.subject,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DesignTokens.space16),

              // Message Body
              Text(
                'Message',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textSubtle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: DesignTokens.space8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.space16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: DesignTokens.borderMd,
                  border: Border.all(color: colors.navBorder),
                ),
                child: Text(
                  message.message,
                  style: textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: DesignTokens.space28),

              // Actions Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext ctx) => AlertDialog(
                          title: const Text('Delete Message?'),
                          content: const Text(
                            'Are you sure you want to delete this message? This action cannot be undone.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.error,
                              ),
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await vm.deleteMessage(message.id);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error, size: 18.0),
                    label: Text(
                      'Delete',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _launchEmail(message.email, message.subject),
                    icon: const Icon(Icons.reply_rounded, size: 18.0),
                    label: const Text('Reply via Email'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
