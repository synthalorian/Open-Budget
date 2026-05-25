import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/data/settings_providers.dart';

/// Supported locales for the app.
const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('es', 'ES'),
];

/// Human-readable language names keyed by locale code.
const Map<String, String> languageNames = {
  'en': 'ENGLISH',
  'es': 'ESPAÑOL',
};

/// Lightweight i18n service for the synthwave neon UI.
/// Returns TRANSLATED UPPERCASE STRINGS matching the app's aesthetic.
class AppLocalizations {
  final String _localeCode;

  AppLocalizations(this._localeCode);

  /// Look up a translation key.
  String t(String key) {
    final translations = _strings[_localeCode];
    if (translations != null && translations.containsKey(key)) {
      return translations[key]!;
    }
    // Fall back to English
    final enTranslations = _strings['en']!;
    return enTranslations[key] ?? key;
  }

  /// Convenience: format a string with a single replacement.
  String tF(String key, String arg) => t(key).replaceAll('{0}', arg);

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      // ── Navigation ──
      'nav_home': 'HOME',
      'nav_budget': 'BUDGET',
      'nav_goals': 'GOALS',
      'nav_insights': 'INSIGHTS',
      'nav_education': 'DOJO',
      'nav_settings': 'CORE',

      // ── Settings sections ──
      'settings_title': 'CORE CONFIG',
      'section_identity': 'IDENTITY',
      'section_aesthetics': 'AESTHETICS',
      'section_modules': 'MODULES',
      'section_alerts': 'ALERTS',
      'section_data': 'DATA MANAGEMENT',
      'section_security': 'SECURITY',
      'section_open_source': 'OPEN_SOURCE',

      // ── Settings items ──
      'user_profile': 'USER PROFILE',
      'currency_protocol': 'CURRENCY PROTOCOL',
      'visual_interface': 'VISUAL INTERFACE',
      'crt_effect': 'CRT EFFECT',
      'crt_effect_sub': 'Scanlines & vignette overlay',
      'auto_theme': 'AUTO THEME SCHEDULE',
      'auto_theme_sub': 'Dark/light by time of day',
      'haptic_feedback': 'HAPTIC FEEDBACK',
      'haptic_feedback_sub': 'Vibration on actions & navigation',
      'sound_effects': 'SOUND EFFECTS',
      'sound_effects_sub': 'Synthwave system audio cues',
      'dark_start_time': 'DARK START TIME',
      'dark_start_time_sub': 'Auto-dark begins at',
      'dark_end_time': 'DARK END TIME',
      'dark_end_time_sub': 'Auto-dark ends at',
      'dark_mode_only': 'DARK MODE ONLY',
      'dark_mode_only_sub': 'Override: always use dark theme',
      'language': 'LANGUAGE',
      'language_sub': 'UI translation',
      'spending_categories': 'SPENDING CATEGORIES',
      'spending_categories_sub': 'CUSTOMIZE DATA MODULES',
      'chronos_module': 'CHRONOS MODULE',
      'chronos_module_sub': 'RECURRING TRANSACTIONS',
      'release_log': 'RELEASE LOG',
      'release_log_sub': 'VERSION HISTORY',
      'widget_tour': 'WIDGET TOUR',
      'widget_tour_sub': 'REPLAY ONBOARDING',
      'cloud_uplink': 'CLOUD UPLINK',
      'cloud_uplink_sub': 'ENCRYPTED SYNC',
      'export_archive': 'EXPORT ARCHIVE',
      'export_archive_sub': 'JSON / CSV',
      'clear_data': 'CLEAR MAIN FRAME',
      'clear_data_sub': 'DESTRUCTIVE',
      'view_error': 'VIEW LAST ERROR',
      'biometric': 'BIOMETRIC FIREWALL',
      'projection_alerts': 'PROJECTION ALERTS',
      'projection_alerts_sub': 'AI collision detection',
      'daily_reminders': 'DAILY REMINDERS',
      'daily_reminders_sub': 'Log transaction prompts',
      'weekly_digest': 'WEEKLY DIGEST',
      'weekly_digest_sub': 'Sunday data summary',

      // ── Theme names ──
      'theme_synthwave84': 'SYNTHWAVE 84',
      'theme_synthwave': 'SYNTHWAVE',
      'theme_normal_dark': 'NORMAL DARK',
      'theme_normal_light': 'NORMAL LIGHT',

      // ── Budget page ──
      'budget_title': 'MAIN FRAME',
      'budget_empty': 'NO MEMORY MODULES DETECTED',
      'add_budget': 'INITIALIZE BUDGET',
      'spent_of': 'SPENT OF {0}',
      'system_health': 'SYSTEM HEALTH',
      'limit': 'LIMIT: {0}',
      'category_limit': 'CATEGORY LIMIT',
      'approaching_limit': 'APPROACHING LIMIT',
      'over_limit': 'OVER LIMIT',

      // ── Categories page ──
      'categories_title': 'MODULE LIBRARY',
      'new_category': 'INITIALIZE NEW MODULE',
      'edit_category': 'EDIT MODULE',
      'delete_category': 'TERMINATE MODULE?',
      'budget_limit': 'BUDGET LIMIT',
      'set_limit': 'SET LIMIT',
      'spent': 'SPENT: {0}',
      'remaining': 'REMAINING: {0}',

      // ── Generic ──
      'save': 'SAVE',
      'cancel': 'CANCEL',
      'commit': 'COMMIT',
      'close': 'CLOSE',
      'delete': 'DELETE',
      'confirm': 'CONFIRM',
      'amount': 'AMOUNT',
      'category': 'CATEGORY',
      'period': 'PERIOD',
      'name': 'NAME',
      'no_data': 'NO DATA',
      'active': 'ACTIVE',
      'inactive': 'INACTIVE',

      // ── Language picker ──
      'select_language': 'SELECT LANGUAGE',
    },
    'es': {
      // ── Navigation ──
      'nav_home': 'INICIO',
      'nav_budget': 'PRESUPUESTO',
      'nav_goals': 'METAS',
      'nav_insights': 'ANÁLISIS',
      'nav_education': 'DOJO',
      'nav_settings': 'NÚCLEO',

      // ── Settings sections ──
      'settings_title': 'CONFIG. NÚCLEO',
      'section_identity': 'IDENTIDAD',
      'section_aesthetics': 'ESTÉTICA',
      'section_modules': 'MÓDULOS',
      'section_alerts': 'ALERTAS',
      'section_data': 'GESTIÓN DATOS',
      'section_security': 'SEGURIDAD',
      'section_open_source': 'CÓDIGO ABIERTO',

      // ── Settings items ──
      'user_profile': 'PERFIL USUARIO',
      'currency_protocol': 'PROTOCOLO MONEDA',
      'visual_interface': 'INTERFAZ VISUAL',
      'crt_effect': 'EFECTO CRT',
      'crt_effect_sub': 'Líneas de escaneo y viñeta',
      'auto_theme': 'TEMA AUTOMÁTICO',
      'auto_theme_sub': 'Oscuro/claro según hora',
      'haptic_feedback': 'RETROALIMENTACIÓN HÁPTICA',
      'haptic_feedback_sub': 'Vibración en acciones y navegación',
      'sound_effects': 'EFECTOS DE SONIDO',
      'sound_effects_sub': 'Audio sintético del sistema',
      'dark_start_time': 'INICIO MODO OSCURO',
      'dark_start_time_sub': 'Oscuro comienza a las',
      'dark_end_time': 'FIN MODO OSCURO',
      'dark_end_time_sub': 'Oscuro termina a las',
      'dark_mode_only': 'SOLO MODO OSCURO',
      'dark_mode_only_sub': 'Anulación: siempre tema oscuro',
      'language': 'IDIOMA',
      'language_sub': 'Traducción de interfaz',
      'spending_categories': 'CATEGORÍAS GASTOS',
      'spending_categories_sub': 'PERSONALIZAR MÓDULOS',
      'chronos_module': 'MÓDULO CRONOS',
      'chronos_module_sub': 'TRANS. RECURRENTES',
      'release_log': 'REGISTRO VERSIONES',
      'release_log_sub': 'HISTORIAL',
      'widget_tour': 'TOUR GUIADO',
      'widget_tour_sub': 'REPRODUCIR INTRODUCCIÓN',
      'cloud_uplink': 'ENLACE NUBE',
      'cloud_uplink_sub': 'SINCRONIZACIÓN ENCRIPTADA',
      'export_archive': 'EXPORTAR ARCHIVO',
      'export_archive_sub': 'JSON / CSV',
      'clear_data': 'BORRAR DATOS',
      'clear_data_sub': 'DESTRUCTIVO',
      'view_error': 'VER ÚLTIMO ERROR',
      'biometric': 'CORTABIEGO BIOMÉTRICO',
      'projection_alerts': 'ALERTAS PROYECCIÓN',
      'projection_alerts_sub': 'Detección de colisiones IA',
      'daily_reminders': 'RECORDATORIOS DIARIOS',
      'daily_reminders_sub': 'Avisos para registrar gastos',
      'weekly_digest': 'RESUMEN SEMANAL',
      'weekly_digest_sub': 'Resumen de datos domingo',

      // ── Theme names ──
      'theme_synthwave84': 'SINTÉTICA 84',
      'theme_synthwave': 'SINTÉTICA',
      'theme_normal_dark': 'NORMAL OSCURO',
      'theme_normal_light': 'NORMAL CLARO',

      // ── Budget page ──
      'budget_title': 'MARCO PRINCIPAL',
      'budget_empty': 'SIN MÓDULOS DETECTADOS',
      'add_budget': 'INICIALIZAR PRESUPUESTO',
      'spent_of': 'GASTADO DE {0}',
      'system_health': 'SALUD DEL SISTEMA',
      'limit': 'LÍMITE: {0}',
      'category_limit': 'LÍMITE CATEGORÍA',
      'approaching_limit': 'ACERCÁNDOSE AL LÍMITE',
      'over_limit': 'EXCEDE LÍMITE',

      // ── Categories page ──
      'categories_title': 'BIBLIOTECA MÓDULOS',
      'new_category': 'INICIALIZAR NUEVO MÓDULO',
      'edit_category': 'EDITAR MÓDULO',
      'delete_category': '¿TERMINAR MÓDULO?',
      'budget_limit': 'LÍMITE PRESUPUESTO',
      'set_limit': 'ESTABLECER LÍMITE',
      'spent': 'GASTADO: {0}',
      'remaining': 'RESTANTE: {0}',

      // ── Generic ──
      'save': 'GUARDAR',
      'cancel': 'CANCELAR',
      'commit': 'CONFIRMAR',
      'close': 'CERRAR',
      'delete': 'ELIMINAR',
      'confirm': 'CONFIRMAR',
      'amount': 'CANTIDAD',
      'category': 'CATEGORÍA',
      'period': 'PERÍODO',
      'name': 'NOMBRE',
      'no_data': 'SIN DATOS',
      'active': 'ACTIVO',
      'inactive': 'INACTIVO',

      // ── Language picker ──
      'select_language': 'SELECCIONAR IDIOMA',
    },
  };
}

/// Provider that serves AppLocalizations based on the user's language setting.
final localeProvider = Provider<AppLocalizations>((ref) {
  final settings = ref.watch(settingsProvider);
  return AppLocalizations(settings.language);
});

/// Provider for the current Locale object (used by MaterialApp).
final currentLocaleProvider = Provider<Locale>((ref) {
  final settings = ref.watch(settingsProvider);
  return Locale(settings.language);
});
