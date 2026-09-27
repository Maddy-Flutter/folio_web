import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/presentation/viewmodels/contact_viewmodel.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:provider/provider.dart';

class ContactSuccessPanel extends StatelessWidget {
  const ContactSuccessPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space32),
      decoration: BoxDecoration(
        color: colors.activeTagBackground,
        borderRadius: DesignTokens.border2Xl,
        border: Border.all(color: colors.activeTagBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.accent,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 32.0,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: DesignTokens.space20),
          Text(
            AppStrings.successTitle,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.space12),
          Text(
            AppStrings.successMessage,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.space28),
          ShimmerButton(
            label: AppStrings.successResetButton,
            onPressed: () {
              context.read<ContactViewModel>().resetForm();
            },
          ),
        ],
      ),
    );
  }
}
