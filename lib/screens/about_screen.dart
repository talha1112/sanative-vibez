import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}