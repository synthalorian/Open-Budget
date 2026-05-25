import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../features/settings/data/settings_providers.dart';
import '../providers/theme_provider.dart';

/// A step in the widget tour.
class _TourStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _TourStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

/// Full-screen tour overlay that appears when the app version has been updated.
/// Shows a series of slides highlighting new features in the current release.
class WidgetTourOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const WidgetTourOverlay({
    super.key,
    required this.child,
    required this.onDismiss,
  });

  @override
  ConsumerState<WidgetTourOverlay> createState() => _WidgetTourOverlayState();
}

class _WidgetTourOverlayState extends ConsumerState<WidgetTourOverlay>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<_TourStep> _steps = [
    _TourStep(
      title: 'AUTO THEME SCHEDULE',
      description: 'The app can now auto-switch between dark and light themes based on the time of day. Configure custom dark-start and dark-end times in CORE CONFIG > AESTHETICS.',
      icon: Icons.schedule_rounded,
      color: AppColors.primary,
    ),
    _TourStep(
      title: 'HAPTIC & SOUND FX',
      description: 'Feel the grid with haptic feedback on navigation and toggle actions. Synthwave system sounds accompany your interactions — toggle both in Aesthetics settings.',
      icon: Icons.vibration_rounded,
      color: AppColors.accent,
    ),
    _TourStep(
      title: 'RELEASE LOG',
      description: 'View the full version history with categorized features and fixes. Found in CORE CONFIG > DATA MANAGEMENT.',
      icon: Icons.history_rounded,
      color: AppColors.income,
    ),
    _TourStep(
      title: 'CUSTOM SCHEDULE TIMES',
      description: 'Set your own dark-theme start and end times. The default 18:00–06:00 is fully configurable to match your routine.',
      icon: Icons.timer_rounded,
      color: AppColors.warning,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _dismiss() {
    // Save current version so tour doesn't show again
    ref.read(settingsProvider.notifier).setLastSeenVersion(AppConstants.appVersion);
    widget.onDismiss();
  }

  void _next() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return Material(
      color: Colors.transparent,
      child: theme.brightness == Brightness.dark
          ? Stack(
              children: [
                widget.child,
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.75),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Synthwave grid in background
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _TourGridPainter(
                                color: AppColors.primary.withValues(alpha: 0.08),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Column(
                          children: [
                            const Spacer(flex: 2),
                            // Header
                            Text(
                              'v${AppConstants.appVersion} UPDATE',
                              style: AppTextStyles.labelNeon.copyWith(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'NEW FEATURES',
                              style: AppTextStyles.headlineMainframe.copyWith(
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'THE GRID HAS BEEN UPGRADED',
                              style: AppTextStyles.labelNeon.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                            const Spacer(),
                            // Slides
                            SizedBox(
                              height: 340,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _steps.length,
                                onPageChanged: (i) => setState(() => _currentPage = i),
                                itemBuilder: (context, index) =>
                                    _buildStepSlide(_steps[index]),
                              ),
                            ),
                            const Spacer(),
                            // Dot indicators + button
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Dots
                                  Row(
                                    children: List.generate(
                                      _steps.length,
                                      (i) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.only(right: 8),
                                        height: 8,
                                        width: i == _currentPage ? 24 : 8,
                                        decoration: BoxDecoration(
                                          color: i == _currentPage
                                              ? AppColors.accent
                                              : AppColors.textMuted,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          boxShadow: i == _currentPage
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.accent
                                                        .withValues(alpha: 0.5),
                                                    blurRadius: 8,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FilledButton(
                                    onPressed: _next,
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          AppColors.primary.withValues(alpha: 0.3),
                                      side: BorderSide(
                                        color: AppColors.accent.withValues(alpha: 0.5),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 28,
                                        vertical: 14,
                                      ),
                                    ),
                                    child: Text(
                                      _currentPage == _steps.length - 1
                                          ? 'ENTER THE GRID'
                                          : 'NEXT',
                                      style: AppTextStyles.labelNeon.copyWith(
                                        color: AppColors.accent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : widget.child, // Don't show tour in light mode
    );
  }

  Widget _buildStepSlide(_TourStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.color.withValues(alpha: 0.15),
              border: Border.all(
                color: step.color.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: step.color.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(step.icon, color: step.color, size: 36),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: AppTextStyles.headlineMainframe.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: AppTextStyles.bodyMain.copyWith(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TourGridPainter extends CustomPainter {
  final Color color;

  _TourGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Provider that checks whether the widget tour should be shown.
/// Returns true if the app was updated since the user last saw the tour.
final shouldShowTourProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsProvider);
  // Show tour if user hasn't seen this version yet
  return settings.lastSeenVersion != AppConstants.appVersion;
});
