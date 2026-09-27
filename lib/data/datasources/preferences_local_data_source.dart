import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PreferencesLocalDataSource {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);
  Future<int?> getLastSubmitTimestamp();
  Future<void> setLastSubmitTimestamp(int timestamp);
}

final class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  PreferencesLocalDataSourceImpl({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;

  Future<SharedPreferences> _getPrefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    final SharedPreferences prefs = await _getPrefs();
    final String? saved = prefs.getString(AppConstants.themePrefKey);
    return switch (saved) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.dark, // Default to sleek dark mode matching modern portfolio
    };
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    final SharedPreferences prefs = await _getPrefs();
    final String val = mode == ThemeMode.light ? 'light' : 'dark';
    await prefs.setString(AppConstants.themePrefKey, val);
  }

  @override
  Future<int?> getLastSubmitTimestamp() async {
    final SharedPreferences prefs = await _getPrefs();
    return prefs.getInt(AppConstants.lastSubmitPrefKey);
  }

  @override
  Future<void> setLastSubmitTimestamp(int timestamp) async {
    final SharedPreferences prefs = await _getPrefs();
    await prefs.setInt(AppConstants.lastSubmitPrefKey, timestamp);
  }
}
