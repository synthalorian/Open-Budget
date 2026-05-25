import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_service.dart';
import '../../../core/domain/entities/settings.dart';
import '../../../shared/providers/database_provider.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsNotifier(db);
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final DatabaseService _db;

  SettingsNotifier(this._db) : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final collision = _db.settings.get('enableCollisionAlerts') as bool? ?? true;
    final critical = _db.settings.get('enableSystemCriticalAlerts') as bool? ?? true;
    final velocity = _db.settings.get('enableVelocityWarnings') as bool? ?? true;
    final currency = _db.settings.get('currencyCode') as String? ?? 'USD';
    final biometric = _db.settings.get('biometricEnabled') as bool? ?? false;
    final themeName = _db.settings.get('themeName') as String? ?? 'synthwave84';
    final userName = _db.settings.get('userName') as String? ?? 'SYNTH_X_84';
    final crt = _db.settings.get('crtEffectEnabled') as bool? ?? true;
    final autoSched = _db.settings.get('autoThemeSchedule') as bool? ?? false;
    final autoDark = _db.settings.get('autoThemeDark') as String? ?? 'synthwave84';
    final autoLight = _db.settings.get('autoThemeLight') as String? ?? 'normal_light';
    final haptic = _db.settings.get('hapticFeedbackEnabled') as bool? ?? true;

    state = AppSettings(
      enableCollisionAlerts: collision,
      enableSystemCriticalAlerts: critical,
      enableVelocityWarnings: velocity,
      currencyCode: currency,
      biometricEnabled: biometric,
      themeName: themeName,
      userName: userName,
      crtEffectEnabled: crt,
      autoThemeSchedule: autoSched,
      autoThemeDark: autoDark,
      autoThemeLight: autoLight,
      hapticFeedbackEnabled: haptic,
    );
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    await _db.settings.put('enableCollisionAlerts', newSettings.enableCollisionAlerts);
    await _db.settings.put('enableSystemCriticalAlerts', newSettings.enableSystemCriticalAlerts);
    await _db.settings.put('enableVelocityWarnings', newSettings.enableVelocityWarnings);
    await _db.settings.put('currencyCode', newSettings.currencyCode);
    await _db.settings.put('biometricEnabled', newSettings.biometricEnabled);
    await _db.settings.put('themeName', newSettings.themeName);
    await _db.settings.put('userName', newSettings.userName);
    await _db.settings.put('crtEffectEnabled', newSettings.crtEffectEnabled);
    await _db.settings.put('autoThemeSchedule', newSettings.autoThemeSchedule);
    await _db.settings.put('autoThemeDark', newSettings.autoThemeDark);
    await _db.settings.put('autoThemeLight', newSettings.autoThemeLight);
    await _db.settings.put('hapticFeedbackEnabled', newSettings.hapticFeedbackEnabled);
    state = newSettings;
  }

  Future<void> toggleCollisionAlerts(bool value) async {
    final newSettings = state.copyWith(enableCollisionAlerts: value);
    await updateSettings(newSettings);
  }

  Future<void> toggleSystemCriticalAlerts(bool value) async {
    final newSettings = state.copyWith(enableSystemCriticalAlerts: value);
    await updateSettings(newSettings);
  }

  Future<void> toggleVelocityWarnings(bool value) async {
    final newSettings = state.copyWith(enableVelocityWarnings: value);
    await updateSettings(newSettings);
  }

  Future<void> toggleBiometrics(bool value) async {
    final newSettings = state.copyWith(biometricEnabled: value);
    await updateSettings(newSettings);
  }

  Future<void> setCurrency(String currencyCode) async {
    final newSettings = state.copyWith(currencyCode: currencyCode);
    await updateSettings(newSettings);
  }

  Future<void> setTheme(String themeName) async {
    final newSettings = state.copyWith(themeName: themeName);
    await updateSettings(newSettings);
  }

  Future<void> setUserName(String userName) async {
    final newSettings = state.copyWith(userName: userName);
    await updateSettings(newSettings);
  }

  Future<void> toggleCrtEffect(bool value) async {
    final newSettings = state.copyWith(crtEffectEnabled: value);
    await updateSettings(newSettings);
  }

  Future<void> toggleAutoThemeSchedule(bool value) async {
    final newSettings = state.copyWith(autoThemeSchedule: value);
    await updateSettings(newSettings);
  }

  Future<void> setAutoThemeDark(String themeName) async {
    final newSettings = state.copyWith(autoThemeDark: themeName);
    await updateSettings(newSettings);
  }

  Future<void> setAutoThemeLight(String themeName) async {
    final newSettings = state.copyWith(autoThemeLight: themeName);
    await updateSettings(newSettings);
  }

  Future<void> toggleHapticFeedback(bool value) async {
    final newSettings = state.copyWith(hapticFeedbackEnabled: value);
    await updateSettings(newSettings);
  }
}
