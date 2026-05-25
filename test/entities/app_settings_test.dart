import 'package:flutter_test/flutter_test.dart';
import 'package:open_budget/core/domain/entities/settings.dart';

void main() {
  group('AppSettings', () {
    test('creates with default values', () {
      final s = const AppSettings();
      expect(s.enableCollisionAlerts, true);
      expect(s.enableSystemCriticalAlerts, true);
      expect(s.enableVelocityWarnings, true);
      expect(s.currencyCode, 'USD');
      expect(s.biometricEnabled, false);
      expect(s.themeName, 'synthwave84');
      expect(s.userName, 'SYNTH_X_84');
      expect(s.crtEffectEnabled, true);
      expect(s.autoThemeSchedule, false);
      expect(s.autoThemeDark, 'synthwave84');
      expect(s.autoThemeLight, 'normal_light');
      expect(s.hapticFeedbackEnabled, true);
      expect(s.soundEffectsEnabled, true);
      expect(s.autoThemeDarkStart, '18:00');
      expect(s.autoThemeDarkEnd, '06:00');
      expect(s.lastSeenVersion, '');
      expect(s.language, 'en');
      expect(s.darkModeOnly, false);
    });

    test('currencySymbol returns correct symbol', () {
      expect(const AppSettings().currencySymbol, '\$');
      expect(const AppSettings(currencyCode: 'EUR').currencySymbol, '€');
      expect(const AppSettings(currencyCode: 'GBP').currencySymbol, '£');
      expect(const AppSettings(currencyCode: 'JPY').currencySymbol, '¥');
      expect(const AppSettings(currencyCode: 'BRL').currencySymbol, 'R\$');
      expect(const AppSettings(currencyCode: 'INR').currencySymbol, '₹');
    });

    test('currencySymbol falls back to \$ for unknown code', () {
      expect(const AppSettings(currencyCode: 'XYZ').currencySymbol, '\$');
    });

    test('copyWith updates only specified fields', () {
      final s = const AppSettings(userName: 'USER_1', themeName: 'dark');
      final updated = s.copyWith(userName: 'USER_2');
      expect(updated.userName, 'USER_2');
      expect(updated.themeName, 'dark');
      expect(updated.currencyCode, 'USD');
    });

    test('copyWith with null fields preserves original', () {
      const s = AppSettings();
      final updated = s.copyWith();
      expect(updated.currencyCode, 'USD');
      expect(updated.themeName, 'synthwave84');
    });

    test('Equatable props contains all fields', () {
      const s = AppSettings();
      expect(s.props.length, 18);
      expect(s.props[3], 'USD');
      expect(s.props[16], 'en');
      expect(s.props[17], false);
    });

    test('two instances with same values are equal', () {
      const a = AppSettings(userName: 'TEST', language: 'es');
      const b = AppSettings(userName: 'TEST', language: 'es');
      expect(a, equals(b));
    });

    test('instances with different values are not equal', () {
      const a = AppSettings(language: 'en');
      const b = AppSettings(language: 'es');
      expect(a, isNot(equals(b)));
    });
  });
}
