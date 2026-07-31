import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../shared/widgets/neon_ui_kit.dart';
import '../features/budget/presentation/pages/budget_page.dart';
import '../features/budget/presentation/pages/recurring_page.dart';
import '../features/transactions/presentation/pages/home_page.dart';
import '../features/transactions/presentation/pages/add_transaction_page.dart';
import '../features/goals/presentation/pages/goals_page.dart';
import '../features/goals/presentation/pages/add_goal_page.dart';
import '../features/insights/presentation/pages/insights_page.dart';
import '../features/education/presentation/pages/education_page.dart';
import '../features/education/presentation/pages/education_detail_page.dart';
import '../features/categories/presentation/pages/categories_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/settings/presentation/pages/onboarding_page.dart';
import '../features/settings/presentation/pages/cloud_sync_page.dart';
import '../features/settings/presentation/pages/changelog_page.dart';
import '../features/settings/data/export_service.dart';
import '../features/settings/data/notification_settings_provider.dart';
import '../features/settings/data/settings_providers.dart';
import '../core/services/haptic_service.dart';
import '../shared/widgets/widget_tour_overlay.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingComplete = ref.watch(notificationSettingsProvider).onboardingComplete;

  return GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
    initialLocation: onboardingComplete ? '/' : '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'shell'),
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/budget',
            name: 'budget',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BudgetPage(),
            ),
          ),
          GoRoute(
            path: '/goals',
            name: 'goals',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GoalsPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: 'add-goal',
                builder: (context, state) => const AddGoalPage(),
              ),
            ],
          ),
          GoRoute(
            path: '/insights',
            name: 'insights',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InsightsPage(),
            ),
          ),
          GoRoute(
            path: '/education',
            name: 'education',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EducationPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: 'educationDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return EducationDetailPage(contentId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CategoriesPage(),
            ),
          ),
          GoRoute(
            path: '/cloud-sync',
            name: 'cloudSync',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CloudSyncPage(),
            ),
          ),
          GoRoute(
            path: '/recurring',
            name: 'recurring',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RecurringPage(),
            ),
          ),
          GoRoute(
            path: '/changelog',
            name: 'changelog',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChangelogPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        name: 'addTransaction',
        pageBuilder: (context, state) {
          final isIncome = state.uri.queryParameters['type'] == 'income';
          return MaterialPage(
            child: AddTransactionPage(isIncome: isIncome),
          );
        },
      ),
      GoRoute(
        path: '/export',
        name: 'export',
        pageBuilder: (context, state) => const MaterialPage(
          child: ExportPage(),
        ),
      ),
    ],
    redirect: (context, state) {
      final isLoggingIn = state.uri.toString() == '/onboarding';
      if (!onboardingComplete && !isLoggingIn) return '/onboarding';
      if (onboardingComplete && isLoggingIn) return '/';
      return null;
    },
  );
});

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/budget')) return 1;
    if (location.startsWith('/goals')) return 2;
    if (location.startsWith('/insights')) return 3;
    if (location.startsWith('/education')) return 4;
    if (location.startsWith('/settings')) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep haptic service in sync with settings
    ref.watch(hapticServiceProvider);
    final currentIndex = _getCurrentIndex(context);
    final settings = ref.watch(settingsProvider);
    final showTour = ref.watch(shouldShowTourProvider);

    Widget shell = CRTOverlay(
      showScanlines: settings.crtEffectEnabled,
      showVignette: settings.crtEffectEnabled,
      child: Scaffold(
        body: Stack(
          children: [
            // Synthwave grid background
            const SynthwaveGrid(),
            child,
          ],
        ),
        bottomNavigationBar: ClipRRect(
          child: Stack(
            children: [
              // Frosted glass nav bar
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: AppColors.background.withValues(alpha: 0.6),
                  ),
                ),
              ),
              NavigationBar(
                selectedIndex: currentIndex,
                height: 65,
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primary.withValues(alpha: 0.2),
                elevation: 0,
                onDestinationSelected: (index) {
                  HapticService().light();
                  switch (index) {
                    case 0: context.go('/'); break;
                    case 1: context.go('/budget'); break;
                    case 2: context.go('/goals'); break;
                    case 3: context.go('/insights'); break;
                    case 4: context.go('/education'); break;
                    case 5: context.go('/settings'); break;
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded),
                    label: 'GRID',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_balance_wallet_rounded),
                    label: 'BUDGET',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.flag_rounded),
                    label: 'GOALS',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.insights_rounded),
                    label: 'INSIGHTS',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.psychology_rounded),
                    label: 'DOJO',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_rounded),
                    label: 'CORE',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (showTour) {
      return WidgetTourOverlay(
        child: shell,
        onDismiss: () {},
      );
    }

    return shell;
  }
}
