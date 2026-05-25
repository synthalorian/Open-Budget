import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 11)
class AppSettings extends Equatable {
  @HiveField(0)
  final bool enableCollisionAlerts;
  
  @HiveField(1)
  final bool enableSystemCriticalAlerts;
  
  @HiveField(2)
  final bool enableVelocityWarnings;
  
  @HiveField(3)
  final String currencyCode;

  @HiveField(4)
  final bool biometricEnabled;

  @HiveField(5)
  final String themeName;

  @HiveField(6)
  final String userName;

  @HiveField(7)
  final bool crtEffectEnabled;

  @HiveField(8)
  final bool autoThemeSchedule;

  @HiveField(9)
  final String autoThemeDark;

  @HiveField(10)
  final String autoThemeLight;

  @HiveField(11)
  final bool hapticFeedbackEnabled;

  @HiveField(12)
  final bool soundEffectsEnabled;

  @HiveField(13)
  final String autoThemeDarkStart;

  @HiveField(14)
  final String autoThemeDarkEnd;

  @HiveField(15)
  final String lastSeenVersion;

  @HiveField(16)
  final String language;

  @HiveField(17)
  final bool darkModeOnly;

  const AppSettings({
    this.enableCollisionAlerts = true,
    this.enableSystemCriticalAlerts = true,
    this.enableVelocityWarnings = true,
    this.currencyCode = 'USD',
    this.biometricEnabled = false,
    this.themeName = 'synthwave84',
    this.userName = 'SYNTH_X_84',
    this.crtEffectEnabled = true,
    this.autoThemeSchedule = false,
    this.autoThemeDark = 'synthwave84',
    this.autoThemeLight = 'normal_light',
    this.hapticFeedbackEnabled = true,
    this.soundEffectsEnabled = true,
    this.autoThemeDarkStart = '18:00',
    this.autoThemeDarkEnd = '06:00',
    this.lastSeenVersion = '',
    this.language = 'en',
    this.darkModeOnly = false,
  });

  String get currencySymbol {
    const currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'MXN': 'MX\$',
      'BRL': 'R\$',
      'KRW': '₩',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NOK': 'kr',
      'SEK': 'kr',
      'DKK': 'kr',
      'NZD': 'NZ\$',
      'ZAR': 'R',
      'RUB': '₽',
      'TRY': '₺',
      'PLN': 'zł',
      'THB': '฿',
      'IDR': 'Rp',
      'MYR': 'RM',
      'PHP': '₱',
      'CZK': 'Kč',
      'ILS': '₪',
      'CLP': 'CLP\$',
      'PKR': '₨',
      'EGP': 'E£',
      'TWD': 'NT\$',
      'AED': 'د.إ',
      'SAR': '﷼',
      'VND': '₫',
    };
    return currencySymbols[currencyCode] ?? '\$';
  }

  AppSettings copyWith({
    bool? enableCollisionAlerts,
    bool? enableSystemCriticalAlerts,
    bool? enableVelocityWarnings,
    String? currencyCode,
    bool? biometricEnabled,
    String? themeName,
    String? userName,
    bool? crtEffectEnabled,
    bool? autoThemeSchedule,
    String? autoThemeDark,
    String? autoThemeLight,
    bool? hapticFeedbackEnabled,
    bool? soundEffectsEnabled,
    String? autoThemeDarkStart,
    String? autoThemeDarkEnd,
    String? lastSeenVersion,
    String? language,
    bool? darkModeOnly,
  }) {
    return AppSettings(
      enableCollisionAlerts: enableCollisionAlerts ?? this.enableCollisionAlerts,
      enableSystemCriticalAlerts: enableSystemCriticalAlerts ?? this.enableSystemCriticalAlerts,
      enableVelocityWarnings: enableVelocityWarnings ?? this.enableVelocityWarnings,
      currencyCode: currencyCode ?? this.currencyCode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      themeName: themeName ?? this.themeName,
      userName: userName ?? this.userName,
      crtEffectEnabled: crtEffectEnabled ?? this.crtEffectEnabled,
      autoThemeSchedule: autoThemeSchedule ?? this.autoThemeSchedule,
      autoThemeDark: autoThemeDark ?? this.autoThemeDark,
      autoThemeLight: autoThemeLight ?? this.autoThemeLight,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      autoThemeDarkStart: autoThemeDarkStart ?? this.autoThemeDarkStart,
      autoThemeDarkEnd: autoThemeDarkEnd ?? this.autoThemeDarkEnd,
      lastSeenVersion: lastSeenVersion ?? this.lastSeenVersion,
      language: language ?? this.language,
      darkModeOnly: darkModeOnly ?? this.darkModeOnly,
    );
  }

  @override
  List<Object?> get props => [
        enableCollisionAlerts,
        enableSystemCriticalAlerts,
        enableVelocityWarnings,
        currencyCode,
        biometricEnabled,
        themeName,
        userName,
        crtEffectEnabled,
        autoThemeSchedule,
        autoThemeDark,
        autoThemeLight,
        hapticFeedbackEnabled,
        soundEffectsEnabled,
        autoThemeDarkStart,
        autoThemeDarkEnd,
        lastSeenVersion,
        language,
        darkModeOnly,
      ];
}
