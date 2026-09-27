import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/profile_content_model.dart';
import 'package:follio/presentation/admin/viewmodels/admin_profile_viewmodel.dart';
import 'package:follio/presentation/widgets/common/photo_frame.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:provider/provider.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _bio1Controller;
  late final TextEditingController _bio2Controller;
  late final TextEditingController _newToolController;
  late final TextEditingController _avatarUrlController;

  @override
  void initState() {
    super.initState();
    final ProfileDraft draft = context.read<AdminProfileViewModel>().draft;
    _nameController = TextEditingController(text: draft.name);
    _roleController = TextEditingController(text: draft.role);
    _bio1Controller = TextEditingController(text: draft.bioPara1);
    _bio2Controller = TextEditingController(text: draft.bioPara2);
    _newToolController = TextEditingController();
    _avatarUrlController = TextEditingController(text: draft.avatarUrl ?? '');
  }

  void _syncControllers(ProfileDraft draft) {
    if (_nameController.text != draft.name) {
      _nameController.text = draft.name;
    }
    if (_roleController.text != draft.role) {
      _roleController.text = draft.role;
    }
    if (_bio1Controller.text != draft.bioPara1) {
      _bio1Controller.text = draft.bioPara1;
    }
    if (_bio2Controller.text != draft.bioPara2) {
      _bio2Controller.text = draft.bioPara2;
    }
    final String currentAvatar = draft.avatarUrl ?? '';
    if (_avatarUrlController.text != currentAvatar) {
      _avatarUrlController.text = currentAvatar;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _bio1Controller.dispose();
    _bio2Controller.dispose();
    _newToolController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminProfileViewModel vm = context.watch<AdminProfileViewModel>();
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    _syncControllers(vm.draft);

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
              'Portfolio Content',
              style: textTheme.labelSmall?.copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: DesignTokens.space4),
            Text(
              'Folio Profile Update',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: DesignTokens.space8),
            Text(
              'Upload an updated resume (PDF or Word) to automatically extract bio, skills, and roles. Edit the draft before publishing live.',
              style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: DesignTokens.space28),

            // Notification banners
            if (vm.errorMessage.isNotEmpty) ...<Widget>[
              _buildNotificationBanner(
                context,
                vm.errorMessage,
                isError: true,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: DesignTokens.space16),
            ],
            if (vm.successMessage.isNotEmpty) ...<Widget>[
              _buildNotificationBanner(
                context,
                vm.successMessage,
                isError: false,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(height: DesignTokens.space16),
            ],

            // Upload Box
            _buildUploadZone(context, vm, colors, colorScheme, textTheme),
            const SizedBox(height: DesignTokens.space36),

            // Editable Draft Form
            _buildDraftForm(context, vm, colors, colorScheme, textTheme),
            const SizedBox(height: DesignTokens.space48),

            // Version History Section
            _buildVersionHistory(context, vm, colors, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBanner(
    BuildContext context,
    String message, {
    required bool isError,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final Color tint = isError ? colorScheme.error : const Color(0xFF10B981);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space14),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: DesignTokens.borderMd,
        border: Border.all(color: tint),
      ),
      child: Row(
        children: <Widget>[
          Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              size: 20.0, color: tint),
          const SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodySmall?.copyWith(
                color: tint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadZone(
    BuildContext context,
    AdminProfileViewModel vm,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.space32),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: DesignTokens.border2Xl,
        border: Border.all(
          color: colors.activeTagBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cloud_upload_outlined, size: 28.0, color: colors.accent),
          ),
          const SizedBox(height: DesignTokens.space16),
          Text(
            'Upload Resume Document',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            'Supports PDF, DOC, DOCX up to 10MB',
            style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: DesignTokens.space20),

          if (vm.isParsing) ...<Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320.0),
              child: Column(
                children: <Widget>[
                  LinearProgressIndicator(
                    value: vm.uploadProgress,
                    color: colors.accent,
                    backgroundColor: colors.tagBorder,
                  ),
                  const SizedBox(height: DesignTokens.space8),
                  Text(
                    'Extracting text & parsing fields...',
                    style: textTheme.labelSmall?.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
          ] else ...<Widget>[
            FilledButton.icon(
              onPressed: vm.pickAndParseFile,
              icon: const Icon(Icons.file_open_rounded, size: 18.0),
              label: const Text('Choose Document'),
            ),
          ],

          if (vm.uploadedFileName != null && !vm.isParsing) ...<Widget>[
            const SizedBox(height: DesignTokens.space16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space16,
                vertical: DesignTokens.space8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: DesignTokens.borderPill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.description_outlined, size: 16.0),
                  const SizedBox(width: DesignTokens.space8),
                  Text(
                    '${vm.uploadedFileName} (${((vm.uploadedFileSizeBytes ?? 0) / 1024).toStringAsFixed(1)} KB)',
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDraftForm(
    BuildContext context,
    AdminProfileViewModel vm,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space32),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: DesignTokens.border2Xl,
        border: Border.all(color: colors.navBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Live Profile Editor (Draft)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              ShimmerButton(
                label: vm.isPublishing ? 'Publishing...' : 'Publish to Live Site',
                isLoading: vm.isPublishing,
                icon: const Icon(Icons.rocket_launch_rounded, size: 16.0),
                onPressed: vm.isPublishing ? null : vm.publish,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space24),

          // Profile Avatar / Image Upload Section
          _buildAvatarUploadCard(context, vm, colors, colorScheme, textTheme),

          // Name and Role
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Full Name', style: textTheme.labelMedium),
                    const SizedBox(height: DesignTokens.space6),
                    TextField(
                      controller: _nameController,
                      onChanged: (String v) => vm.updateDraft(name: v),
                      decoration: const InputDecoration(hintText: 'e.g. Eliott'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Title / Role', style: textTheme.labelMedium),
                    const SizedBox(height: DesignTokens.space6),
                    TextField(
                      controller: _roleController,
                      onChanged: (String v) => vm.updateDraft(role: v),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Freelance UI/UX Designer & Frontend Dev',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space20),

          // Bio Paragraph 1
          Text('Bio Paragraph 1 (Introduction)', style: textTheme.labelMedium),
          const SizedBox(height: DesignTokens.space6),
          TextField(
            controller: _bio1Controller,
            maxLines: 3,
            onChanged: (String v) => vm.updateDraft(bioPara1: v),
            decoration: const InputDecoration(hintText: 'First introductory paragraph'),
          ),
          const SizedBox(height: DesignTokens.space20),

          // Bio Paragraph 2
          Text('Bio Paragraph 2 (Approach & Focus)', style: textTheme.labelMedium),
          const SizedBox(height: DesignTokens.space6),
          TextField(
            controller: _bio2Controller,
            maxLines: 3,
            onChanged: (String v) => vm.updateDraft(bioPara2: v),
            decoration: const InputDecoration(hintText: 'Second paragraph regarding design philosophy'),
          ),
          const SizedBox(height: DesignTokens.space24),

          // Stack & Tools
          Text('Tools & Technologies', style: textTheme.labelMedium),
          const SizedBox(height: DesignTokens.space8),
          Wrap(
            spacing: DesignTokens.space8,
            runSpacing: DesignTokens.space8,
            children: vm.draft.tools.map((String tool) {
              return Chip(
                label: Text(tool),
                deleteIcon: const Icon(Icons.close_rounded, size: 14.0),
                onDeleted: () {
                  final List<String> updated = List<String>.from(vm.draft.tools)..remove(tool);
                  vm.updateDraft(tools: updated);
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: DesignTokens.borderPill,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: DesignTokens.space12),

          // Add tool input
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240.0),
                child: TextField(
                  controller: _newToolController,
                  decoration: const InputDecoration(
                    hintText: 'Add new tool/skill',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.space12,
                      vertical: DesignTokens.space8,
                    ),
                  ),
                  onSubmitted: (String v) {
                    if (v.trim().isNotEmpty) {
                      final List<String> updated = List<String>.from(vm.draft.tools)..add(v.trim());
                      vm.updateDraft(tools: updated);
                      _newToolController.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: DesignTokens.space12),
              OutlinedButton.icon(
                onPressed: () {
                  final String v = _newToolController.text.trim();
                  if (v.isNotEmpty) {
                    final List<String> updated = List<String>.from(vm.draft.tools)..add(v);
                    vm.updateDraft(tools: updated);
                    _newToolController.clear();
                  }
                },
                icon: const Icon(Icons.add_rounded, size: 16.0),
                label: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVersionHistory(
    BuildContext context,
    AdminProfileViewModel vm,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space32),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: DesignTokens.border2Xl,
        border: Border.all(color: colors.navBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.history_rounded, size: 20.0),
              const SizedBox(width: DesignTokens.space8),
              Text(
                'Version History (Last 5 Published)',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space16),

          if (vm.versions.isEmpty)
            Text(
              'No previous versions recorded.',
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.versions.length,
              separatorBuilder: (_, _) => const Divider(height: 1.0),
              itemBuilder: (BuildContext context, int index) {
                final ProfileVersion ver = vm.versions[index];
                final bool isCurrent = index == 0;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: DesignTokens.space6),
                  leading: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: isCurrent ? colors.accent : colorScheme.surfaceContainerHighest,
                    child: Text(
                      'v${vm.versions.length - index}',
                      style: textTheme.labelSmall?.copyWith(
                        color: isCurrent ? colorScheme.onPrimary : colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  title: Text(
                    '${ver.draft.name} — ${ver.draft.role}',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Published on ${_formatDate(ver.publishedAt)}',
                    style: textTheme.labelSmall?.copyWith(color: colors.textSubtle),
                  ),
                  trailing: isCurrent
                      ? Chip(
                          label: const Text('Live'),
                          backgroundColor: colors.activeTagBackground,
                          labelStyle: TextStyle(color: colors.accent, fontWeight: FontWeight.bold),
                        )
                      : OutlinedButton(
                          onPressed: () async {
                            final bool success = await vm.revertToVersion(ver.versionId);
                            if (success) {
                              _syncControllers(vm.draft);
                            }
                          },
                          child: const Text('Revert'),
                        ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarUploadCard(
    BuildContext context,
    AdminProfileViewModel vm,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final bool isMobile = ResponsiveUtils.isMobile(context);
    final String avatarUrl = vm.draft.avatarUrl ?? ProfileDraft.defaultAvatarUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.space20),
      margin: const EdgeInsets.only(bottom: DesignTokens.space28),
      decoration: BoxDecoration(
        color: colors.sectionAlternateBackground,
        borderRadius: DesignTokens.borderXl,
        border: Border.all(color: colors.activeTagBorder.withValues(alpha: 0.5)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAvatarPreview(vm, avatarUrl, colors),
                const SizedBox(height: DesignTokens.space16),
                _buildAvatarControls(context, vm, colors, colorScheme, textTheme),
              ],
            )
          : Row(
              children: <Widget>[
                _buildAvatarPreview(vm, avatarUrl, colors),
                const SizedBox(width: DesignTokens.space24),
                Expanded(
                  child: _buildAvatarControls(context, vm, colors, colorScheme, textTheme),
                ),
              ],
            ),
    );
  }

  Widget _buildAvatarPreview(
    AdminProfileViewModel vm,
    String avatarUrl,
    PortfolioColors colors,
  ) {
    return Stack(
      children: <Widget>[
        Container(
          width: 104.0,
          height: 104.0,
          decoration: BoxDecoration(
            borderRadius: DesignTokens.border2Xl,
            border: Border.all(color: colors.accent, width: 2.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.accent.withValues(alpha: 0.15),
                blurRadius: 16.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: PhotoFrame(
            imageUrl: avatarUrl,
            altText: 'Profile Avatar Preview',
            width: 100.0,
            height: 100.0,
            borderRadius: DesignTokens.borderXl,
          ),
        ),
        if (vm.isUploadingAvatar)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: DesignTokens.border2Xl,
              ),
              child: const Center(
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarControls(
    BuildContext context,
    AdminProfileViewModel vm,
    PortfolioColors colors,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Profile Avatar',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: DesignTokens.space8),
            if (vm.hasCustomAvatar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.12),
                  borderRadius: DesignTokens.borderPill,
                  border: Border.all(color: colors.accent),
                ),
                child: Text(
                  'Custom',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: DesignTokens.space4),
        Text(
          'Upload an image (PNG, JPG, WEBP, GIF up to 5MB) or enter an external image URL below.',
          style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
        ),
        const SizedBox(height: DesignTokens.space12),

        // Action Buttons: Upload & Reset
        Wrap(
          spacing: DesignTokens.space12,
          runSpacing: DesignTokens.space8,
          children: <Widget>[
            FilledButton.icon(
              onPressed: vm.isUploadingAvatar ? null : vm.pickAndUploadAvatar,
              icon: const Icon(Icons.photo_camera_rounded, size: 16.0),
              label: Text(vm.isUploadingAvatar ? 'Uploading...' : 'Upload Image'),
            ),
            if (vm.hasCustomAvatar)
              OutlinedButton.icon(
                onPressed: vm.resetAvatar,
                icon: const Icon(Icons.refresh_rounded, size: 16.0),
                label: const Text('Reset to Default'),
              ),
          ],
        ),
        const SizedBox(height: DesignTokens.space12),

        // Or direct URL input
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _avatarUrlController,
                decoration: const InputDecoration(
                  hintText: 'Or paste image URL (https://...)',
                  isDense: true,
                  prefixIcon: Icon(Icons.link_rounded, size: 18.0),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.space12,
                    vertical: DesignTokens.space10,
                  ),
                ),
                onSubmitted: (String v) {
                  if (v.trim().isNotEmpty) {
                    vm.updateAvatarUrl(v.trim());
                  }
                },
              ),
            ),
            const SizedBox(width: DesignTokens.space8),
            IconButton.filledTonal(
              tooltip: 'Apply URL',
              icon: const Icon(Icons.check_rounded, size: 18.0),
              onPressed: () {
                final String v = _avatarUrlController.text.trim();
                if (v.isNotEmpty) {
                  vm.updateAvatarUrl(v);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
