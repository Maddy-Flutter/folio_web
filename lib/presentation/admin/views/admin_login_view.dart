import 'package:flutter/material.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/presentation/admin/viewmodels/admin_auth_viewmodel.dart';
import 'package:follio/presentation/viewmodels/view_state.dart';
import 'package:follio/presentation/widgets/common/shimmer_button.dart';
import 'package:follio/presentation/widgets/nav/theme_toggle_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final PortfolioColors colors = context.portfolioColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final AdminAuthViewModel authVm = context.watch<AdminAuthViewModel>();
    final bool isLoading = authVm.viewState == ViewState.loading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: <Widget>[
          // Background ambient glows
          Positioned(
            top: -60.0,
            left: -60.0,
            child: IgnorePointer(
              child: Container(
                width: 320.0,
                height: 320.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      colors.accent.withValues(alpha: 0.12),
                      colors.accent.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 24.0,
            right: 24.0,
            child: ThemeToggleButton(),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.space24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440.0),
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.space36),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: DesignTokens.border2Xl,
                    border: Border.all(color: colors.navBorder),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.06),
                        blurRadius: 24.0,
                        offset: const Offset(0.0, 8.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Brand Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Folio',
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Admin',
                            style: textTheme.headlineMedium?.copyWith(
                              color: colors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.space8),
                      Text(
                        'Sign in to manage messages, visitors, and portfolio content.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignTokens.space28),

                      // Error banner
                      if (authVm.errorMessage.isNotEmpty) ...<Widget>[
                        Container(
                          padding: const EdgeInsets.all(DesignTokens.space12),
                          margin: const EdgeInsets.only(bottom: DesignTokens.space16),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withValues(alpha: 0.12),
                            borderRadius: DesignTokens.borderMd,
                            border: Border.all(color: colorScheme.error),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.error_outline_rounded,
                                size: 18.0,
                                color: colorScheme.error,
                              ),
                              const SizedBox(width: DesignTokens.space10),
                              Expanded(
                                child: Text(
                                  authVm.errorMessage,
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

                      // Username field
                      Text(
                        'Username',
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space6),
                      TextField(
                        onChanged: authVm.setUsername,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g. Madhavan',
                          errorText: authVm.usernameError,
                          prefixIcon: const Icon(Icons.person_outline_rounded, size: 20.0),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space18),

                      // Password field
                      Text(
                        'Password',
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space6),
                      TextField(
                        obscureText: authVm.obscurePassword,
                        onChanged: authVm.setPassword,
                        onSubmitted: (_) async {
                          final bool success = await authVm.login();
                          if (success && context.mounted) {
                            context.go('/admin/dashboard');
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          errorText: authVm.passwordError,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authVm.obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18.0,
                            ),
                            onPressed: authVm.toggleObscurePassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space28),

                      // Sign In Button
                      ShimmerButton(
                        label: isLoading ? 'Signing in...' : 'Sign in to Console',
                        isLoading: isLoading,
                        padding: const EdgeInsets.symmetric(vertical: DesignTokens.space16),
                        borderRadius: DesignTokens.borderLg,
                        onPressed: isLoading
                            ? null
                            : () async {
                                final bool success = await authVm.login();
                                if (success && context.mounted) {
                                  context.go('/admin/dashboard');
                                }
                              },
                      ),
                      const SizedBox(height: DesignTokens.space20),

                      // Info callout on credentials
                      Container(
                        padding: const EdgeInsets.all(DesignTokens.space12),
                        decoration: BoxDecoration(
                          color: colors.activeTagBackground,
                          borderRadius: DesignTokens.borderMd,
                          border: Border.all(color: colors.activeTagBorder),
                        ),
                        child: Text(
                          'Test Credentials: Username: "Madhavan" | Password: "220701"',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
