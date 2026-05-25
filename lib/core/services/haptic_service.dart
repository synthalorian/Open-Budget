import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/settings_providers.dart';

/// Manages haptic feedback and synthwave sound effects across the app.
/// Both haptics and sounds are independently gated by user settings.
class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _hapticEnabled = true;
  bool _soundEnabled = true;

  /// Call on settings load to sync enabled state.
  void setEnabled({required bool haptic, required bool sound}) {
    _hapticEnabled = haptic;
    _soundEnabled = sound;
  }

  // ── Haptic methods ──

  /// Light tap — navigation, button presses.
  Future<void> light() async {
    if (_hapticEnabled) await HapticFeedback.lightImpact();
    if (_soundEnabled) await SystemSound.play(SystemSoundType.click);
  }

  /// Medium tap — toggle switches, card selections.
  Future<void> medium() async {
    if (_hapticEnabled) await HapticFeedback.mediumImpact();
    if (_soundEnabled) await SystemSound.play(SystemSoundType.click);
  }

  /// Heavy tap — destructive actions, confirmations.
  Future<void> heavy() async {
    if (_hapticEnabled) await HapticFeedback.heavyImpact();
    if (_soundEnabled) await SystemSound.play(SystemSoundType.alert);
  }

  /// Selection feedback — picker selections, list items.
  Future<void> selection() async {
    if (_hapticEnabled) await HapticFeedback.selectionClick();
    if (_soundEnabled) await SystemSound.play(SystemSoundType.click);
  }

  /// Success notification — operations that complete successfully.
  Future<void> success() async {
    if (_hapticEnabled) await HapticFeedback.mediumImpact();
    if (_soundEnabled) await SystemSound.play(SystemSoundType.alert);
  }

  /// Error notification — failed operations.
  Future<void> error() async {
    if (_hapticEnabled) await HapticFeedback.heavyImpact();
    if (_soundEnabled) await SystemSound.play(SystemSoundType.alert);
  }

  // ── Sound-only methods ──

  /// Play a click sound without haptics.
  Future<void> soundClick() async {
    if (_soundEnabled) await SystemSound.play(SystemSoundType.click);
  }

  /// Play an alert sound without haptics.
  Future<void> soundAlert() async {
    if (_soundEnabled) await SystemSound.play(SystemSoundType.alert);
  }
}

/// Provider that watches the settings and keeps HapticService in sync.
final hapticServiceProvider = Provider<HapticService>((ref) {
  final settings = ref.watch(settingsProvider);
  final service = HapticService();
  service.setEnabled(
    haptic: settings.hapticFeedbackEnabled,
    sound: settings.soundEffectsEnabled,
  );
  return service;
});
