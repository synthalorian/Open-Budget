import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neon_ui_kit.dart';

class _ChangelogEntry {
  final String version;
  final String date;
  final List<String> features;
  final List<String> fixes;

  const _ChangelogEntry({
    required this.version,
    required this.date,
    required this.features,
    this.fixes = const [],
  });
}

const _changelogEntries = <_ChangelogEntry>[
  _ChangelogEntry(
    version: 'v1.1.2',
    date: '2025-05-25',
    features: [
      'Auto theme schedule — dark/light themes based on time of day',
      'Haptic feedback system with per-action vibrations',
      'Changelog screen with full version history',
      'CRT toggle persisted across sessions',
    ],
    fixes: [
      'Fixed updateSettings persistence typo for CRT effect key',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.1.1',
    date: '2025-05-25',
    features: [
      'CRT effect toggle in Aesthetics settings',
      'Smooth animated theme transitions (600ms easeInOut)',
      'GitHub Actions CI/CD workflow for auto APK builds',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.1.0',
    date: '2025-05-25',
    features: [
      'SYNTHWAVE_84 theme — deep purple grid, electric purple, yellow & pink',
      'CRT scanline overlay with vignette effect across the entire app',
      'Synthwave grid background pattern on every page',
      'Enhanced multi-layered neon glow effects with pulsing animations',
      'Synthwave section headers with glow accent bars',
      'Frosted glass navigation bar with blur effect',
      'Synthwave-styled buttons, progress bars, and text inputs',
    ],
    fixes: [
      'Fixed Color.value deprecation → toARGB32()',
      'Fixed unnecessary .toList() in spread operations',
      'Fixed duplicate import in education_detail_page',
      '50+ analyzer issues resolved — 0 warnings/errors',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.0.9',
    date: '2025-05-24',
    features: [
      'Added PURGE animation — shrink-to-nothing delete transition',
      'Income/outflow filter chips on home page',
      'Replaced static home page card with animated NeonCard',
    ],
    fixes: [
      'Fixed budget sheet type inference crash',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.0.8',
    date: '2025-05-23',
    features: [
      'Normal dark/light themes for daytime use',
      'Eliminated add-transaction page delay',
    ],
    fixes: [
      'Fixed theme persistence across app restarts',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.0.7',
    date: '2025-05-22',
    features: [
      'Education module (DOJO) with financial literacy content',
      'Recurring transaction engine (Chronos module)',
      'Export service with JSON/CSV archive support',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.0.6',
    date: '2025-05-21',
    features: [
      'Nebula insights page with spending charts',
      'Goal tracking with progress orb',
      'Cloud sync stubs',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.0.5',
    date: '2025-05-20',
    features: [
      'Budget management with category allocation',
      'Transaction log with income/expense filtering',
      'Hive local database with encryption layer',
    ],
  ),
  _ChangelogEntry(
    version: 'v1.0.0',
    date: '2025-05-18',
    features: [
      'Initial release — Open Budget alpha',
      'Basic CRUD for transactions',
      'Neon synthwave UI foundation',
    ],
  ),
];

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('RELEASE LOG', style: AppTextStyles.headlineMainframe),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.spaceGradient),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
          children: [
            Center(
              child: Text(
                'OPEN_BUDGET v${AppConstants.appVersion}',
                style: AppTextStyles.headlineMainframe.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'BY SYNTH AND SYNTHCLAW 🎹🦞',
                style: AppTextStyles.labelNeon.copyWith(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ..._changelogEntries.map((entry) => _buildChangelogCard(entry)),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildChangelogCard(_ChangelogEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: NeonCard(
        padding: const EdgeInsets.all(20),
        opacity: 0.2,
        hasGlow: false,
        borderColor: AppColors.surfaceLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.version,
                  style: AppTextStyles.headlineTitle.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  entry.date,
                  style: AppTextStyles.labelNeon.copyWith(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Divider(color: AppColors.surfaceLight, thickness: 0.5),
            const SizedBox(height: 12),
            if (entry.features.isNotEmpty) ...[
              Text(
                'FEATURES',
                style: AppTextStyles.labelNeon.copyWith(
                  fontSize: 10,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              ...entry.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('+ ', style: TextStyle(
                      color: AppColors.income,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
                    Expanded(
                      child: Text(
                        f,
                        style: AppTextStyles.bodyMain.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
            ],
            if (entry.fixes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'FIXES',
                style: AppTextStyles.labelNeon.copyWith(
                  fontSize: 10,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 8),
              ...entry.fixes.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('~ ', style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
                    Expanded(
                      child: Text(
                        f,
                        style: AppTextStyles.bodyMain.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
