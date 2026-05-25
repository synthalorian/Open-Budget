import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/settings_providers.dart';

/// Manages haptic feedback and sound effects across the app.
/// All haptics are gated by the user's hapticFeedbackEnabled setting.
class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _enabled = true;

  /// Call on settings load to sync enabled state.
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Light tap — navigation, button presses.
  Future<void> light() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Medium tap — toggle switches, card selections.
  Future<void> medium() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Heavy tap — destructive actions, confirmations.
  Future<void> heavy() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Selection feedback — picker selections, list items.
  Future<void> selection() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Success notification — operations that complete successfully.
  Future<void> success() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Error notification — failed operations.
  Future<void> error() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }
}

/// Provider that watches the settings and keeps HapticService in sync.
final hapticServiceProvider = Provider<HapticService>((ref) {
  final settings = ref.watch(settingsProvider);
  final service = HapticService();
  service.setEnabled(settings.hapticFeedbackEnabled);
  return service;
});
