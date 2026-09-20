import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavDestinations {
  static const int home = 0;
  static const int daily = 1;
  static const int calmLibrary = 2;
  static const int vibeWithUs = 3;
  static const int about = 4;
}

class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  Future<void> _launchVibeWithUsUrl(BuildContext context) async {
    final url = Uri.parse('https://www.sanativevibez.com/start-your-7-day-experience');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This will open in your device\'s browser.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This will open in your device\'s browser.')),
        );
      }
    }
  }

  int _mapBranchToIndex(int branchIndex) {
    if (branchIndex == 0) return BottomNavDestinations.home;
    if (branchIndex == 1) return BottomNavDestinations.daily;
    if (branchIndex == 2) return BottomNavDestinations.calmLibrary;
    if (branchIndex == 3) return BottomNavDestinations.about;
    return 0;
  }

  int _mapIndexToBranch(int index) {
    if (index == BottomNavDestinations.home) return 0;
    if (index == BottomNavDestinations.daily) return 1;
    if (index == BottomNavDestinations.calmLibrary) return 2;
    if (index == BottomNavDestinations.about) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colors.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return typography.labelSmall?.copyWith(
                fontSize: 10,
                color: isSelected ? colors.primary : colors.onSurface.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ) ?? const TextStyle(fontSize: 10);
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: isSelected ? colors.primary : colors.onSurface.withValues(alpha: 0.5),
              );
            }),
            indicatorColor: colors.primaryContainer.withValues(alpha: 0.5),
          ),
          child: NavigationBar(
            selectedIndex: _mapBranchToIndex(navigationShell.currentIndex),
            onDestinationSelected: (index) {
              if (index == BottomNavDestinations.vibeWithUs) {
                _launchVibeWithUsUrl(context);
                return;
              }
              final branchIndex = _mapIndexToBranch(index);
              navigationShell.goBranch(
                branchIndex,
                initialLocation: branchIndex == navigationShell.currentIndex,
              );
            },
            backgroundColor: colors.surface,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.wb_sunny_outlined),
                label: 'Daily',
              ),
              NavigationDestination(
                icon: Icon(Icons.eco_outlined),
                label: 'Calm',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_awesome_outlined),
                label: 'Vibe With Us',
              ),
              NavigationDestination(
                icon: Icon(Icons.info_outline),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}