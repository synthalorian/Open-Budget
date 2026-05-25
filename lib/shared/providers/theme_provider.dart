import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/entities/settings.dart';
import '../../features/settings/data/settings_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/neon_themes.dart';

/// Determines the effective theme name based on the auto-schedule setting.
///
/// If autoThemeSchedule is enabled, returns the dark or light theme based on
/// current time (dark 18:00–06:00, light 06:00–18:00). Otherwise returns the
/// user's manually selected theme.
String _resolveThemeName(AppSettings settings) {
  if (!settings.autoThemeSchedule) return settings.themeName;

  final now = DateTime.now();
  // Dark hours: 18:00 (6 PM) to 06:00 (6 AM)
  final hour = now.hour;
  final isDarkTime = hour >= 18 || hour < 6;
  return isDarkTime ? settings.autoThemeDark : settings.autoThemeLight;
}

/// A timer that fires every 60 seconds so the theme provider can re-evaluate
/// the auto-schedule at runtime (picks up 6AM/6PM transitions without restart).
final _themeTickProvider = StreamProvider.autoDispose<void>((ref) {
  return Stream.periodic(const Duration(seconds: 60), (_) => null);
});

final themeProvider = Provider<ThemeData>((ref) {
  // Watch the timer so the theme rebuilds on schedule transitions
  ref.watch(_themeTickProvider);
  final settings = ref.watch(settingsProvider);
  final effectiveName = _resolveThemeName(settings);
  final neonTheme = NeonThemes.byName(effectiveName);
  return AppTheme.createTheme(neonTheme);
});

/// Provides the resolved theme name (useful for display purposes).
final effectiveThemeNameProvider = Provider<String>((ref) {
  ref.watch(_themeTickProvider);
  final settings = ref.watch(settingsProvider);
  return _resolveThemeName(settings);
});
