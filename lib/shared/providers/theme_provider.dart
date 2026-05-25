import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/entities/settings.dart';
import '../../features/settings/data/settings_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/neon_themes.dart';

/// Parse a "HH:MM" time string and return the total minutes from midnight.
int _parseTimeMinutes(String time) {
  final parts = time.split(':');
  final hour = int.tryParse(parts[0]) ?? 18;
  final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
  return hour * 60 + minute;
}

/// Returns true if [now] falls within the dark-period window defined by
/// [darkStart] and [darkEnd] (both "HH:MM" strings).
///
/// Handles overnight ranges (e.g., 18:00–06:00) correctly.
bool _isDarkTime(DateTime now, String darkStart, String darkEnd) {
  final nowMinutes = now.hour * 60 + now.minute;
  final startMinutes = _parseTimeMinutes(darkStart);
  final endMinutes = _parseTimeMinutes(darkEnd);

  if (startMinutes <= endMinutes) {
    // Same-day range (e.g., 06:00–18:00)
    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  } else {
    // Overnight range (e.g., 18:00–06:00)
    return nowMinutes >= startMinutes || nowMinutes < endMinutes;
  }
}

/// Determines the effective theme name based on the auto-schedule setting.
///
/// If autoThemeSchedule is enabled, returns the dark or light theme based on
/// the user-configurable dark-start and dark-end times. Otherwise returns the
/// user's manually selected theme.
String _resolveThemeName(AppSettings settings) {
  if (!settings.autoThemeSchedule) return settings.themeName;

  final now = DateTime.now();
  final isDark = _isDarkTime(now, settings.autoThemeDarkStart, settings.autoThemeDarkEnd);
  return isDark ? settings.autoThemeDark : settings.autoThemeLight;
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
