import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/neon_ui_kit.dart';
import '../../data/notification_settings_provider.dart';
import '../../data/settings_providers.dart';
import '../../../../core/services/security_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
    final appSettings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('CORE config', style: AppTextStyles.headlineMainframe),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.spaceGradient),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
          children: [
            _buildSectionHeader('IDENTITY'),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'USER PROFILE', 'SYNth_x_84', Icons.person_rounded, AppColors.primary, null),
            _buildSettingsItem(context, 'Currency Protocol', 'USD (\$)', Icons.monetization_on_rounded, AppColors.primary, null),
            
            const SizedBox(height: 32),
            _buildSectionHeader('MODULES'),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'Spending categories', 'customize data modules', Icons.category_rounded, AppColors.accent, '/categories'),
            
            const SizedBox(height: 32),
            _buildSectionHeader('alerts'),
            const SizedBox(height: 16),
            _buildToggleItem(
              'Projection alerts',
              'AI collision detection',
              Icons.bolt_rounded,
              notificationSettings.projectionAlerts,
              (val) => notificationNotifier.updateSettings(projectionAlerts: val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              'Daily reminders',
              'Log transaction logs',
              Icons.notifications_active_rounded,
              notificationSettings.dailyReminders,
              (val) => notificationNotifier.updateSettings(dailyReminders: val),
            ),
            const SizedBox(height: 12),
            _buildToggleItem(
              'weekly digest',
              'Sunday data summary',
              Icons.summarize_rounded,
              notificationSettings.weeklyDigest
              (val) => notificationNotifier.updateSettings(weeklyDigest: val),
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('data management'),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'Cloud Uplink', 'Encrypted sync', Icons.cloud_sync_rounded, AppColors.accent, '/cloud-sync'),
            _buildSettingsItem(context, 'Export archive', 'JSON /CSV', Icons.download_rounded, AppColors.accent, '/export'),
            _buildSettingsItem(context, 'Clear main frame', ' destructive', Icons.delete_forever_rounded, AppColors.expense, null),
            
            const SizedBox(height: 32),
            _buildSectionHeader('security'),
            const SizedBox(height: 16),
            _buildBiometricToggle(context, settingsNotifier, appSettings.biometricEnabled),
            const SizedBox(height: 32),
            _buildSectionHeader('Open source'),
            const SizedBox(height: 16),
            _buildSettingsItem(context, 'GitHub repository', 'github.com/synthalorian/open-budget', Icons.code_rounded, AppColors.primary, null, url: 'https://github.com/synthalorian/open-budget'),
            _buildSettingsItem(context, 'Support development', 'Buy me a coffee', Icons.coffee_rounded, AppColors.warning, null, url: 'https://www.buymeacoffee.com/synthalorian'),
            _buildSectionHeader('Community'),
            Text('GITHUB Repository', style: AppTextStyles.labelNeon),
            const SizedBox(height: 4),
            Text('Support Development', style: AppTextStyles.labelNeon.copyWith(color: AppColors.warning),
          ],
        ),
        SizedBox(height: 32),
        Text('Licensed under MPL-2.0', style: AppTextStyles.labelNeon.copyWith(fontSize: 10, color: AppColors.accent),
      ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.labelNeon),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, String value, IconData icon, Color color, String? route, {String? url}) {
    return GestureDetector(
      onTap: () async {
        if (url != null) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri, mode: LaunchMode.externalApplication)) {
            }
          }
        } else if (route != null) {
          context.push(route);
        }
      },
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
            ],
          if (route != null || url != null)
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, IconData icon, bool value, Function(bool onChanged) {
    return NeonCard(
      padding: const EdgeInsets.all(16),
      opacity: 0.2,
      hasGlow: value,
      glowColor: value ? AppColors.accent : AppColors.surfaceLight,
      borderColor: value ? AppColors.accent : AppColors.surfaceLight,
      child: Row(
        children: [
          Icon(icon, color: value ? AppColors.accent : AppColors.textMuted, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Switch(
              value: value,
              onChanged: (val) => onChanged(val),
              activeColor: AppColors.accent,
              inactiveTrackColor: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
