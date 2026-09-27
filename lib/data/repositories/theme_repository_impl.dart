import 'package:flutter/material.dart';
import 'package:follio/data/datasources/preferences_local_data_source.dart';
import 'package:follio/domain/repositories/theme_repository.dart';

final class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl({required PreferencesLocalDataSource preferencesDataSource})
      : _preferencesDataSource = preferencesDataSource;

  final PreferencesLocalDataSource _preferencesDataSource;

  @override
  Future<ThemeMode> getSavedThemeMode() {
    return _preferencesDataSource.getThemeMode();
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) {
    return _preferencesDataSource.setThemeMode(mode);
  }
}
