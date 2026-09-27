import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/presentation/viewmodels/contact_viewmodel.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:provider/provider.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _subjectController;
  late final TextEditingController _messageController;
  late final TextEditingController _honeypotController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _subjectFocusNode;
  late final FocusNode _messageFocusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();
    _honeypotController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<ContactViewModel>().onNameBlur();
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<ContactViewModel>().onEmailBlur();
      }
    });

    _subjectFocusNode.addListener(() {
      if (!_subjectFocusNode.hasFocus) {
        context.read<ContactViewModel>().onSubjectBlur();
      }
    });

    _messageFocusNode.addListener(() {
      if (!_messageFocusNode.hasFocus) {
        context.read<ContactViewModel>().onMessageBlur();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _honeypotController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ContactViewModel vm = context.watch<ContactViewModel>();
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Error banner if submit failed
        if (vm.hasError) ...<Widget>[
          Container(
            padding: const EdgeInsets.all(DesignTokens.space14),
            margin: const EdgeInsets.only(bottom: DesignTokens.space20),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.15),
              borderRadius: DesignTokens.borderMd,
              border: Border.all(color: colorScheme.error),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline_rounded,
                  size: 20.0,
                  color: colorScheme.error,
                ),
                const SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: Text(
                    vm.errorMessage,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Hidden honeypot field (invisible to real users, catches bots)
        Opacity(
          opacity: 0.0,
          child: SizedBox(
            height: 0.0,
            width: 0.0,
            child: TextField(
              controller: _honeypotController,
              canRequestFocus: false,
              onChanged: vm.setHoneypot,
            ),
          ),
        ),

        // Name and Email fields (Responsive row or column)
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isNarrow = constraints.maxWidth < 460;
            if (isNarrow) {
              return Column(
                children: <Widget>[
                  _buildNameField(vm, textTheme, colors, colorScheme),
                  const SizedBox(height: DesignTokens.space16),
                  _buildEmailField(vm, textTheme, colors, colorScheme),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildNameField(vm, textTheme, colors, colorScheme)),
                const SizedBox(width: DesignTokens.space16),
                Expanded(child: _buildEmailField(vm, textTheme, colors, colorScheme)),
              ],
            );
          },
        ),
        const SizedBox(height: DesignTokens.space16),

        // Subject field
        _buildSubjectField(vm, textTheme, colors, colorScheme),
        const SizedBox(height: DesignTokens.space16),

        // Message field
        _buildMessageField(vm, textTheme, colors, colorScheme),
        const SizedBox(height: DesignTokens.space24),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: ShimmerButton(
            label: vm.isSubmitting ? AppStrings.formSubmitting : AppStrings.formSubmitButton,
            isLoading: vm.isSubmitting,
            padding: const EdgeInsets.symmetric(vertical: DesignTokens.space16),
            borderRadius: DesignTokens.borderLg,
            onPressed: vm.isSubmitting
                ? null
                : () async {
                    final bool success = await vm.submit();
                    if (success && mounted) {
                      _nameController.clear();
                      _emailController.clear();
                      _subjectController.clear();
                      _messageController.clear();
                      _honeypotController.clear();
                    }
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(
    ContactViewModel vm,
    TextTheme textTheme,
    PortfolioColors colors,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${AppStrings.formNameLabel} *',
          style: textTheme.labelMedium?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignTokens.space6),
        TextField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          onChanged: vm.setName,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: AppStrings.formNamePlaceholder,
            errorText: vm.nameError,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(
    ContactViewModel vm,
    TextTheme textTheme,
    PortfolioColors colors,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${AppStrings.formEmailLabel} *',
          style: textTheme.labelMedium?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignTokens.space6),
        TextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          onChanged: vm.setEmail,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: AppStrings.formEmailPlaceholder,
            errorText: vm.emailError,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectField(
    ContactViewModel vm,
    TextTheme textTheme,
    PortfolioColors colors,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.formSubjectLabel,
          style: textTheme.labelMedium?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignTokens.space6),
        TextField(
          controller: _subjectController,
          focusNode: _subjectFocusNode,
          onChanged: vm.setSubject,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: AppStrings.formSubjectPlaceholder,
            errorText: vm.subjectError,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageField(
    ContactViewModel vm,
    TextTheme textTheme,
    PortfolioColors colors,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${AppStrings.formMessageLabel} *',
          style: textTheme.labelMedium?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: DesignTokens.space6),
        TextField(
          controller: _messageController,
          focusNode: _messageFocusNode,
          maxLines: 4,
          onChanged: vm.setMessage,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: AppStrings.formMessagePlaceholder,
            errorText: vm.messageError,
          ),
        ),
      ],
    );
  }
}
