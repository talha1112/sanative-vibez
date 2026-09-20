import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _launchSevenDayPracticeUrl(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final String currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WELCOME HEADER (Premium Redesign)
            Container(
              height: 260,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.xl),
                  bottomRight: Radius.circular(AppRadius.xl),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Base background
                  Container(color: const Color(0xFFFCFAF5)), // Warm ivory
                  
                  // Top left deep plum
                  Positioned(
                    top: -60, left: -40,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF523B51).withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Bottom right sage
                  Positioned(
                    bottom: -80, right: -60,
                    child: Container(
                      width: 250, height: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A9681).withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Top right champagne-gold
                  Positioned(
                    top: 20, right: -20,
                    child: Container(
                      width: 150, height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5D5B5).withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Blur overlay for atmospheric effect
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(
                        // Dark translucent overlay for text readability
                        color: Colors.black.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  
                  // Content
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Untitled_design_5_-removebg-preview.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'SANATIVE VIBEZ',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            _getGreeting(),
                            style: typography.displayMedium?.copyWith(
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'A moment to return to yourself.',
                            style: typography.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            currentDate,
                            style: typography.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. DAILY STRESS CHECK-IN
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How are you today?',
                          style: typography.headlineMedium?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Tap the one that feels closest. There is no wrong answer.',
                          style: typography.bodyMedium?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _StressCard(
                          title: 'Grounded',
                          subtitle: 'Mostly steady today',
                          onTap: () => context.push(Uri(path: '/check-in', queryParameters: {'feeling': 'Grounded'}).toString()),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _StressCard(
                          title: 'Full',
                          subtitle: 'Carrying a little more',
                          onTap: () => context.push(Uri(path: '/check-in', queryParameters: {'feeling': 'Full'}).toString()),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _StressCard(
                          title: 'Weary',
                          subtitle: 'A lot to hold',
                          onTap: () => context.push(Uri(path: '/check-in', queryParameters: {'feeling': 'Weary'}).toString()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 3. 7-DAY PERSONAL PRACTICE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Sanative Vibez Experience',
                          style: typography.titleLarge?.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Explore seven days of intentional affirmations, reflection, and personal practice—at your own pace.',
                          style: typography.bodyMedium?.copyWith(
                            color: colors.onPrimary.withValues(alpha: 0.95),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _launchSevenDayPracticeUrl(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.onPrimary,
                              foregroundColor: colors.primary,
                            ),
                            child: const Text('Vibe With Us'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 4. WHERE TO NEXT
                  Text(
                    'WHERE TO NEXT',
                    style: typography.labelMedium?.copyWith(
                      color: colors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: [
                        _ActionCard(
                          title: 'Today\'s Daily Prompt',
                          subtitle: 'Do · Reflect · Affirm',
                          backgroundColor: colors.secondaryContainer,
                          iconColor: colors.onSecondaryContainer,
                          icon: Icons.wb_sunny_outlined,
                          onTap: () => context.push('/prompt'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _ActionCard(
                          title: 'Calm Library',
                          subtitle: 'Short practices for busy days.',
                          backgroundColor: colors.primaryContainer,
                          iconColor: colors.onPrimaryContainer,
                          icon: Icons.eco_outlined,
                          onTap: () => context.push('/calm-library'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _ActionCard(
                          title: 'Reflection History',
                          subtitle: 'Revisit your past check-ins and reflections.',
                          backgroundColor: colors.tertiaryContainer,
                          iconColor: colors.onTertiaryContainer,
                          icon: Icons.auto_stories_outlined,
                          onTap: () => context.push('/insights'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  const SizedBox(height: AppSpacing.xl),

                  // 5. CLOSING QUOTE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                      horizontal: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: colors.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: colors.primary.withValues(alpha: 0.3),
                          size: 40,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '“You don\'t have to feel calm to begin. You only have to begin gently.”',
                          textAlign: TextAlign.center,
                          style: typography.titleLarge?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.8),
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _StressCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: colors.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: typography.titleLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: typography.bodyMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: colors.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).textTheme;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: typography.titleMedium?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: typography.bodySmall?.copyWith(
                    color: iconColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}