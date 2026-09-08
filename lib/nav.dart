import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/bottom_nav.dart';
import 'screens/home_screen.dart';
import 'screens/daily_prompt_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/about_screen.dart';
import 'screens/check_in_flow.dart';
import 'screens/calm_library_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// App router configuration
class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: Daily
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/prompt',
                builder: (context, state) => const DailyPromptScreen(),
              ),
            ],
          ),
          // Branch 2: Calm Library
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calm-library',
                builder: (context, state) => const CalmLibraryScreen(),
              ),
            ],
          ),
          // Branch 3: About
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
      // Full screen check-in flow outside the shell
      GoRoute(
        path: '/check-in',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final feeling = state.uri.queryParameters['feeling'];
          return CustomTransitionPage(
            child: CheckInFlowScreen(initialFeeling: feeling),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/practice',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra;
          Map<String, dynamic> practice = {};
          if (extra is Map<String, dynamic>) {
            practice = extra;
          } else if (extra is Map) {
            practice = Map<String, dynamic>.from(extra);
          }
          return PracticeDetailScreen(practice: practice);
        },
      ),
      GoRoute(
        path: '/insights',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InsightsScreen(),
      ),
    ],
  );
}