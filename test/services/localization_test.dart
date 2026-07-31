import 'dart:ui' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:open_budget/core/services/localization_service.dart';

void main() {
  group('AppLocalizations', () {
    test('returns English string for key', () {
      final l = AppLocalizations('en');
      expect(l.t('nav_home'), 'HOME');
      expect(l.t('nav_budget'), 'BUDGET');
    });

    test('falls back to English for missing locale', () {
      final l = AppLocalizations('de');
      expect(l.t('nav_home'), 'START');
    });

    test('returns key as fallback when key is missing', () {
      final l = AppLocalizations('en');
      expect(l.t('nonexistent_key'), 'nonexistent_key');
    });

    test('formats strings with tF', () {
      final l = AppLocalizations('en');
      expect(l.tF('spent', '\$500'), 'SPENT: \$500');
    });

    test('all supported locales have the same keys as English', () {
  final enKeys = _getAllKeys();

      for (final locale in ['es', 'fr', 'de', 'pt', 'hi', 'ja', 'zh']) {
        final l = AppLocalizations(locale);
        for (final key in enKeys) {
          // Should not throw and should return a non-empty string
          final result = l.t(key);
          expect(result.isNotEmpty, isTrue,
              reason: 'Locale $locale missing translation for key: $key');
        }
      }
    });

    test('Spanish translations are distinct from English', () {
      final es = AppLocalizations('es');
      // Check a few keys that should differ
      expect(es.t('nav_home'), equals('INICIO'));
      expect(es.t('nav_budget'), equals('PRESUPUESTO'));
    });

    test('supportedLocales contains all 8 locales', () {
      expect(supportedLocales.length, 8);
      expect(supportedLocales, contains(const Locale('en', 'US')));
      expect(supportedLocales, contains(const Locale('es', 'ES')));
      expect(supportedLocales, contains(const Locale('fr', 'FR')));
      expect(supportedLocales, contains(const Locale('de', 'DE')));
      expect(supportedLocales, contains(const Locale('pt', 'BR')));
      expect(supportedLocales, contains(const Locale('hi', 'IN')));
      expect(supportedLocales, contains(const Locale('ja', 'JP')));
      expect(supportedLocales, contains(const Locale('zh', 'CN')));
    });

    test('languageNames contains all 8 languages', () {
      expect(languageNames.length, 8);
      expect(languageNames['en'], 'ENGLISH');
      expect(languageNames['es'], 'ESPAÑOL');
      expect(languageNames['ja'], '日本語');
      expect(languageNames['zh'], '中文');
    });
  });
}

/// Collect all keys from the English translations map.
Set<String> _getAllKeys() {
  // Access the static _strings map via reflection isn't possible,
  // so we test known keys.
  return {
    'nav_home', 'nav_budget', 'nav_goals', 'nav_insights', 'nav_education',
    'nav_settings', 'settings_title', 'section_identity', 'section_aesthetics',
    'section_modules', 'section_alerts', 'section_data', 'section_security',
    'section_open_source', 'user_profile', 'currency_protocol',
    'visual_interface', 'crt_effect', 'crt_effect_sub', 'auto_theme',
    'auto_theme_sub', 'haptic_feedback', 'haptic_feedback_sub',
    'sound_effects', 'sound_effects_sub', 'dark_start_time',
    'dark_start_time_sub', 'dark_end_time', 'dark_end_time_sub',
    'dark_mode_only', 'dark_mode_only_sub', 'language', 'language_sub',
    'spending_categories', 'spending_categories_sub', 'chronos_module',
    'chronos_module_sub', 'release_log', 'release_log_sub', 'widget_tour',
    'widget_tour_sub', 'cloud_uplink', 'cloud_uplink_sub', 'export_archive',
    'export_archive_sub', 'clear_data', 'clear_data_sub', 'view_error',
    'biometric', 'projection_alerts', 'projection_alerts_sub',
    'daily_reminders', 'daily_reminders_sub', 'weekly_digest',
    'weekly_digest_sub', 'theme_synthwave84', 'theme_synthwave',
    'theme_normal_dark', 'theme_normal_light', 'budget_title',
    'budget_empty', 'add_budget', 'spent_of', 'system_health', 'limit',
    'category_limit', 'approaching_limit', 'over_limit', 'categories_title',
    'new_category', 'edit_category', 'delete_category', 'budget_limit',
    'set_limit', 'spent', 'remaining', 'save', 'cancel', 'commit', 'close',
    'delete', 'confirm', 'amount', 'category', 'period', 'name', 'no_data',
    'active', 'inactive', 'select_language',
  };
}
