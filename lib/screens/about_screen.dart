import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../services/storage_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchWebsiteUrl(BuildContext context) async {
    final url = Uri.parse('https://www.sanativevibez.com');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the website.')),
        );
      }
    }
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')),
        );
      }
    }
  }

  Future<void> _confirmAndClearData(BuildContext context) async {
    final colors = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear My Data'),
        content: const Text(
          'This will permanently delete your locally stored check-ins and reflections from this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await StorageService().clearAllUserData();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your data has been cleared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/Untitled_design_5_-removebg-preview.png',
                  width: 240,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'About Sanative Vibez',
                style: typography.displaySmall?.copyWith(
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              Text(
                'Sanative Vibez is a calm daily companion for reflection, intention, and personal practice.',
                style: typography.bodyLarge?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Through brief check-ins, calming practices, affirmations, and gentle daily prompts, Sanative Vibez offers a private space to pause, reflect, and notice your own patterns with curiosity.',
                style: typography.bodyLarge?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Pause. Reflect. Return to yourself.',
                style: typography.titleMedium?.copyWith(
                  color: colors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Note about support
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: colors.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: colors.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'A note about support',
                          style: typography.titleMedium?.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Sanative Vibez is a non-clinical space for personal reflection and daily practice. It is not medical care, psychotherapy, diagnosis, or treatment, and it is not a substitute for professional help. If you feel unsafe or need urgent support, contact local emergency services or a qualified professional in your area.',
                      style: typography.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),

              // Vibe With Us
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vibe With Us',
                      style: typography.titleLarge?.copyWith(
                        color: colors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Explore seven days of intentional affirmations, reflection, and personal practice—at your own pace.',
                      style: typography.bodyMedium?.copyWith(
                        color: colors.onSecondaryContainer.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => _launchUrl(context, 'https://www.sanativevibez.com/start-your-7-day-experience'),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.onSecondaryContainer,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Learn About the 7-Day Practice'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Center(
                child: TextButton(
                  onPressed: () => _launchWebsiteUrl(context),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primary.withValues(alpha: 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  ),
                  child: const Text('Visit Sanative Vibez online'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Clear My Data
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: colors.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your data',
                      style: typography.titleMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your check-ins and reflections are stored only on this device. You can permanently delete them at any time.',
                      style: typography.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _confirmAndClearData(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.error,
                          side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                        ),
                        child: const Text('Clear My Data'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}