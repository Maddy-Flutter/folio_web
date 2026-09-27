import 'package:flutter/material.dart';
import 'package:follio/domain/repositories/theme_repository.dart';

final class ThemeViewModel extends ChangeNotifier {
  ThemeViewModel({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository {
    _loadTheme();
  }

  final ThemeRepository _themeRepository;
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isDisposed = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    _themeMode = await _themeRepository.getSavedThemeMode();
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    if (!_isDisposed) {
      notifyListeners();
    }
    await _themeRepository.saveThemeMode(_themeMode);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
