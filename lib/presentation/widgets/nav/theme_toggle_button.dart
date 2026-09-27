import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/presentation/viewmodels/theme_viewmodel.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.select<ThemeViewModel, bool>(
      (ThemeViewModel vm) => vm.isDarkMode,
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: isDark ? AppStrings.toggleLightMode : AppStrings.toggleDarkMode,
      child: Tooltip(
        message: isDark ? AppStrings.toggleLightMode : AppStrings.toggleDarkMode,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.read<ThemeViewModel>().toggleTheme();
            },
            child: Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline,
                ),
              ),
              child: Center(
                child: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 18.0,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
