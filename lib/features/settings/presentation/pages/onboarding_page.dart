import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/neon_ui_kit.dart';
import '../../data/notification_settings_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'WELCOME TO THE GRID',
      description: 'Your financial mainframe is online. Track every data packet (dollar) with precision.',
      icon: Icons.grid_view_rounded,
      color: AppColors.primary,
    ),
    OnboardingSlide(
      title: 'THE PULSE ORB',
      description: 'Monitor your spending velocity in real-time. If the pulse turns red, the system is in critical load.',
      icon: Icons.bolt_rounded,
      color: AppColors.accent,
    ),
    OnboardingSlide(
      title: 'STRATEGY DOJO',
      description: 'Master the arts of zero-sum budgeting and subscription purging to optimize your net worth.',
      icon: Icons.psychology_rounded,
      color: AppColors.income,
    ),
    OnboardingSlide(
      title: 'AI PROJECTION',
      description: 'The mainframe predicts your future balance based on current spending trajectory.',
      icon: Icons.radar_rounded,
      color: AppColors.warning,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.spaceGradient),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) => _buildSlide(_slides[index]),
            ),
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => _buildDot(index == _currentPage),
                    ),
                  ),
                  _buildActionButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeonPulseOrb(percentUsed: 0.5, baseColor: slide.color),
          const SizedBox(height: 60),
          Text(
            slide.title,
            style: AppTextStyles.headlineMainframe.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            slide.description,
            style: AppTextStyles.bodyMain,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: active ? 24 : 8,
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.textMuted,
        borderRadius: BorderRadius.circular(4),
        boxShadow: active ? [
          BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 8),
        ] : null,
      ),
    );
  }

  Widget _buildActionButton() {
    final isLast = _currentPage == _slides.length - 1;
    return TextButton(
      onPressed: () async {
        if (isLast) {
          await ref.read(notificationSettingsProvider.notifier).setOnboardingComplete();
          if (mounted) context.go('/');
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Text(
        isLast ? 'INITIALIZE' : 'NEXT',
        style: AppTextStyles.labelNeon.copyWith(
          color: AppColors.accent,
          fontSize: 16,
        ),
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
