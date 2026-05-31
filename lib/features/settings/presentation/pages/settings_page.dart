import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/neon_themes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/domain/entities/settings.dart';
import '../../../../shared/widgets/neon_ui_kit.dart';
import '../../data/notification_settings_provider.dart';
import '../../data/settings_providers.dart';
import '../../../../core/services/security_service.dart';
import '../../../../main.dart' show lastFlutterError;
import '../../data/export_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../shared/widgets/widget_tour_overlay.dart';
import '../../../../core/services/localization_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
    final appSettings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final l = ref.watch(localeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l.t('settings_title'), style: AppTextStyles.headlineMainframe),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.spaceGradient),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
          children: [
            SynthwaveSectionHeader(title: l.t('section_identity'), accentColor: AppColors.primary),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              'USER PROFILE',
              appSettings.userName,
              Icons.person_rounded,
              AppColors.primary,
              null,
              onTap: () => _showUserNameEditor(context, settingsNotifier, appSettings),
            ),
            _buildCurrencySelector(context, settingsNotifier, appSettings),
            
            const SizedBox(height: 32),
            SynthwaveSectionHeader(title: l.t('section_aesthetics'), accentColor: AppColors.primary),
            const SizedBox(height: 16),
            _buildThemeSelector(context, settingsNotifier, appSettings),
            const SizedBox(height: 12),
            _buildToggleItem(
              l.t('crt_effect'),
              l.t('crt_effect_sub'),
              Icons.monitor_rounded,
              appSettings.crtEffectEnabled,
              (val) => settingsNotifier.toggleCrtEffect(val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              l.t('auto_theme'),
              l.t('auto_theme_sub'),
              Icons.schedule_rounded,
              appSettings.autoThemeSchedule,
              (val) => settingsNotifier.toggleAutoThemeSchedule(val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              l.t('dark_mode_only'),
              l.t('dark_mode_only_sub'),
              Icons.dark_mode_rounded,
              appSettings.darkModeOnly,
              (val) => settingsNotifier.toggleDarkModeOnly(val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              l.t('haptic_feedback'),
              l.t('haptic_feedback_sub'),
              Icons.vibration_rounded,
              appSettings.hapticFeedbackEnabled,
              (val) => settingsNotifier.toggleHapticFeedback(val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              l.t('sound_effects'),
              l.t('sound_effects_sub'),
              Icons.music_note_rounded,
              appSettings.soundEffectsEnabled,
              (val) => settingsNotifier.toggleSoundEffects(val),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              context,
              l.t('language'),
              languageNames[appSettings.language] ?? 'ENGLISH',
              Icons.language_rounded,
              AppColors.accent,
              null,
              onTap: () => _showLanguageSelector(context, ref, appSettings, settingsNotifier),
            ),
            if (appSettings.autoThemeSchedule) ...[const SizedBox(height: 12)],
            if (appSettings.autoThemeSchedule)
              _buildTimePickerItem(
                context,
                l.t('dark_start_time'),
                l.t('dark_start_time_sub'),
                Icons.nights_stay_rounded,
                appSettings.autoThemeDarkStart,
                (time) => settingsNotifier.setAutoThemeDarkStart(time),
              ),
            if (appSettings.autoThemeSchedule) ...[const SizedBox(height: 12)],
            if (appSettings.autoThemeSchedule)
              _buildTimePickerItem(
                context,
                l.t('dark_end_time'),
                l.t('dark_end_time_sub'),
                Icons.wb_sunny_rounded,
                appSettings.autoThemeDarkEnd,
                (time) => settingsNotifier.setAutoThemeDarkEnd(time),
              ),

            const SizedBox(height: 32),
            SynthwaveSectionHeader(title: l.t('section_modules'), accentColor: AppColors.accent),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'SPENDING_CATEGORIES', 'CUSTOMIZE DATA_MODULES', Icons.category_rounded, AppColors.accent, '/categories'),
            _buildSettingsItem(context, 'CHRONOS_MODULE', 'RECURRING_TRANSACTIONS', Icons.history_toggle_off_rounded, AppColors.accent, '/recurring'),
            
            const SizedBox(height: 32),
            SynthwaveSectionHeader(title: l.t('section_alerts'), accentColor: AppColors.accent),
            const SizedBox(height: 16),
            _buildToggleItem(
              'PROJECTION_ALERTS',
              'AI collision detection',
              Icons.bolt_rounded,
              notificationSettings.projectionAlerts,
              (val) => notificationNotifier.updateSettings(projectionAlerts: val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              'DAILY_REMINDERS',
              'Log transaction prompts',
              Icons.notifications_active_rounded,
              notificationSettings.dailyReminders,
              (val) => notificationNotifier.updateSettings(dailyReminders: val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              'WEEKLY_DIGEST',
              'Sunday data summary',
              Icons.summarize_rounded,
              notificationSettings.weeklyDigest,
              (val) => notificationNotifier.updateSettings(weeklyDigest: val),
            ),

            const SizedBox(height: 32),
            SynthwaveSectionHeader(title: l.t('section_data'), accentColor: AppColors.accent),
            const SizedBox(height: 16),
            _buildSettingsItem(context, l.t('widget_tour'), l.t('widget_tour_sub'), Icons.explore_rounded, AppColors.accent, null, onTap: () => _showWidgetTour(context, ref)),
            const SizedBox(height: 12),
            _buildSettingsItem(context, 'RELEASE_LOG', 'VERSION HISTORY', Icons.history_rounded, AppColors.accent, '/changelog'),
            _buildSettingsItem(context, 'CLOUD_UPLINK', 'ENCRYPTED_SYNC', Icons.cloud_sync_rounded, AppColors.accent, '/cloud-sync'),
            _buildSettingsItem(context, 'EXPORT_ARCHIVE', 'JSON / CSV', Icons.download_rounded, AppColors.accent, '/export'),
            _buildSettingsItem(
              context,
              'CLEAR_MAIN_FRAME',
              'DESTRUCTIVE',
              Icons.delete_forever_rounded,
              AppColors.expense,
              null,
              onTap: () => showClearDataDialog(context, ref),
            ),
            _buildSettingsItem(
              context,
              'VIEW_LAST_ERROR',
              lastFlutterError.isEmpty ? 'NO ERRORS CAPTURED' : 'TAP TO VIEW',
              Icons.bug_report_rounded,
              AppColors.warning,
              null,
              onTap: () => _showLastError(context),
            ),
            
            const SizedBox(height: 32),
            SynthwaveSectionHeader(title: l.t('section_security'), accentColor: AppColors.accent),
            const SizedBox(height: 16),
            _buildBiometricToggle(context, settingsNotifier, appSettings.biometricEnabled),
            
            const SizedBox(height: 32),
            SynthwaveSectionHeader(title: l.t('section_open_source'), accentColor: AppColors.primary),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'GITHUB_REPOSITORY', 'github.com/synthalorian/open-budget', Icons.code_rounded, AppColors.primary, null, url: 'https://github.com/synthalorian/open-budget'),
            _buildSettingsItem(context, 'SUPPORT_DEVELOPMENT', 'buymeacoffee.com/synthalorian', Icons.coffee_rounded, AppColors.warning, null, url: 'https://buymeacoffee.com/synthalorian'),
            
            const SizedBox(height: 48),
            Center(
              child: Text(
                'OPEN_BUDGET v${AppConstants.appVersion}\nBY SYNTH AND SYNTHSHARK 🎹🦈',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelNeon.copyWith(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWidgetTour(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => WidgetTourOverlay(
        child: const SizedBox.shrink(),
        onDismiss: () => Navigator.pop(ctx),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref, AppSettings settings, SettingsNotifier notifier) {
    final l = ref.read(localeProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.t('select_language'), style: AppTextStyles.headlineMainframe.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            ...languageNames.entries.map((entry) {
              final isSelected = entry.key == settings.language;
              return GestureDetector(
                onTap: () {
                  notifier.setLanguage(entry.key);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.language_rounded, color: isSelected ? AppColors.accent : AppColors.textMuted),
                      const SizedBox(width: 16),
                      Text(entry.value, style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                      const Spacer(),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded, color: AppColors.accent),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String currentTime,
    Function(String) onTimePicked,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _showTimePicker(context, currentTime, onTimePicked),
        child: NeonCard(
          padding: const EdgeInsets.all(16),
          opacity: 0.2,
          hasGlow: true,
          glowColor: AppColors.primary.withValues(alpha: 0.3),
          borderColor: AppColors.primary.withValues(alpha: 0.4),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.bodyMain.copyWith(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  currentTime,
                  style: AppTextStyles.labelNeon.copyWith(
                    color: AppColors.accent,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.edit_rounded, color: AppColors.textMuted, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context, String currentTime, Function(String) onTimePicked) {
    final parts = currentTime.split(':');
    final initialHour = int.tryParse(parts[0]) ?? 18;
    final initialMinute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.surface,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1A0030),
            ),
          ),
          child: child!,
        );
      },
    ).then((time) {
      if (time != null) {
        final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        onTimePicked(formatted);
      }
    });
  }

  Widget _buildSettingsItem(BuildContext context, String title, String value, IconData icon, Color color, String? route, {String? url, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () async {
        if (url != null) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } else if (route != null) {
          context.push(route);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: NeonCard(
          padding: const EdgeInsets.all(16),
          opacity: 0.2,
          hasGlow: false,
          borderColor: AppColors.surfaceLight,
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(value, style: AppTextStyles.bodyMain.copyWith(fontSize: 10, color: color)),
                  ],
                ),
              ),
              if (route != null || url != null)
                Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        padding: const EdgeInsets.all(16),
        opacity: 0.2,
        hasGlow: value,
        glowColor: AppColors.accent,
        borderColor: value ? AppColors.accent.withValues(alpha: 0.5) : AppColors.surfaceLight,
        child: Row(
          children: [
            Icon(icon, color: value ? AppColors.accent : AppColors.textMuted, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                  Text(subtitle, style: AppTextStyles.bodyMain.copyWith(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: (v) {
                HapticService().selection();
                onChanged(v);
              },
              activeThumbColor: AppColors.accent,
              activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
              inactiveThumbColor: AppColors.textMuted,
              inactiveTrackColor: AppColors.surfaceLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricToggle(BuildContext context, SettingsNotifier notifier, bool isEnabled) {
    return FutureBuilder<bool>(
      future: SecurityService().isBiometricAvailable(),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: NeonCard(
            padding: const EdgeInsets.all(16),
            opacity: 0.2,
            hasGlow: isEnabled,
            glowColor: AppColors.accent,
            borderColor: isEnabled ? AppColors.accent : AppColors.surfaceLight,
            child: Row(
              children: [
                Icon(Icons.fingerprint_rounded, color: isEnabled ? AppColors.accent : AppColors.textMuted, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BIOMETRIC_FIREWALL', style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        isAvailable ? (isEnabled ? 'ACTIVE_ENCRYPTION' : 'TAP_TO_ENABLE') : 'NO_HARDWARE_DETECTED',
                        style: AppTextStyles.bodyMain.copyWith(fontSize: 10, color: isEnabled ? AppColors.accent : AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: isAvailable ? (val) => notifier.toggleBiometrics(val) : null,
                  activeThumbColor: AppColors.accent,
                  activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
                  inactiveThumbColor: AppColors.textMuted,
                  inactiveTrackColor: AppColors.surfaceLight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencySelector(BuildContext context, SettingsNotifier notifier, AppSettings settings) {
    final currencies = AppConstants.supportedCurrencies;
    return _buildSettingsItem(
      context, 
      'CURRENCY_PROTOCOL', 
      '${settings.currencyCode} (${settings.currencySymbol})', 
      Icons.monetization_on_rounded, 
      AppColors.primary, 
      null,
      onTap: () => _showCurrencySelector(context, notifier, settings, currencies),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsNotifier notifier, AppSettings settings) {
    final currentTheme = NeonThemes.byName(settings.themeName);
    return _buildSettingsItem(
      context, 
      'VISUAL_INTERFACE', 
      currentTheme.displayName, 
      Icons.palette_rounded, 
      AppColors.primary, 
      null,
      onTap: () => _showThemeSelector(context, notifier, settings),
    );
  }

  void _showLastError(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('LAST_ERROR', style: AppTextStyles.labelNeon.copyWith(color: AppColors.warning)),
        content: SingleChildScrollView(
          child: SelectableText(
            lastFlutterError.isEmpty ? 'No errors captured since app start.' : lastFlutterError,
            style: AppTextStyles.bodyMain.copyWith(fontSize: 11),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CLOSE', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  void _showUserNameEditor(BuildContext context, SettingsNotifier notifier, AppSettings settings) {
    final controller = TextEditingController(text: settings.userName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REASSIGN_IDENTITY', style: AppTextStyles.headlineMainframe.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              autofocus: true,
              style: AppTextStyles.bodyMain,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'USER_HANDLE',
                labelStyle: AppTextStyles.labelNeon.copyWith(fontSize: 8, color: AppColors.textMuted),
                prefixIcon: Icon(Icons.person_rounded, color: AppColors.accent, size: 20),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    notifier.setUserName(name);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text('COMMIT_IDENTITY', style: AppTextStyles.labelNeon.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencySelector(BuildContext context, SettingsNotifier notifier, AppSettings settings, Map<String, String> currencies) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SELECT_CURRENCY_PROTOCOL', style: AppTextStyles.headlineMainframe.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final code = currencies.keys.elementAt(index);
                  final symbol = currencies[code]!;
                  final isSelected = code == settings.currencyCode;
                  
                  return GestureDetector(
                    onTap: () {
                      notifier.setCurrency(code);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(symbol, style: AppTextStyles.moneyLarge.copyWith(fontSize: 20)),
                          const SizedBox(width: 16),
                          Text(code, style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                          const Spacer(),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: AppColors.accent),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context, SettingsNotifier notifier, AppSettings settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SELECT_INTERFACE_SKIN', style: AppTextStyles.headlineMainframe.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: NeonThemes.all.length,
                itemBuilder: (context, index) {
                  final theme = NeonThemes.all[index];
                  final isSelected = theme.name == settings.themeName;
                  
                  return GestureDetector(
                    onTap: () {
                      notifier.setTheme(theme.name);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.primary.withValues(alpha: 0.2) : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? theme.primary : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: theme.primary.withValues(alpha: 0.5), blurRadius: 8)],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(theme.displayName, style: AppTextStyles.headlineTitle.copyWith(fontSize: 14)),
                              Text(theme.description, style: AppTextStyles.bodyMain.copyWith(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: theme.accent),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
