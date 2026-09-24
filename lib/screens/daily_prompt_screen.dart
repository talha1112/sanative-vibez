import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../theme.dart';
import '../services/storage_service.dart';

class DailyPromptScreen extends StatefulWidget {
  const DailyPromptScreen({super.key});

  @override
  State<DailyPromptScreen> createState() => _DailyPromptScreenState();
}

class _DailyPromptScreenState extends State<DailyPromptScreen> {
  final StorageService _storage = StorageService();
  final TextEditingController _journalController = TextEditingController();
  
  final List<String> prompts = [
    'What would feel a little lighter today?',
    'What is one thing you can release for now?',
    'Where could you offer yourself more patience?',
    'What helps you return to yourself?',
    'What is one small act of care you can choose today?',
    'What went well today, even in a small way?',
    'What do you need more of right now?'
  ];

  final List<String> affirmations = [
    'I am allowed to pause.',
    'I can choose one small next step.',
    'I meet myself with patience.',
    'My needs matter.',
    'I can release what is not mine to carry.',
    'I trust myself to move gently through this moment.',
    'I have permission to rest and reset.'
  ];

  final List<String> _chipOptions = [
    'I need this today',
    'I\'m thinking about it',
    'I feel ready for a next step',
  ];

  late String dailyPrompt;
  late String dailyAffirmation;
  String? _selectedChip;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    final random = Random();
    dailyPrompt = prompts[random.nextInt(prompts.length)];
    dailyAffirmation = affirmations[random.nextInt(affirmations.length)];
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _launchFrequenciesUrl(BuildContext context) async {
    final url = Uri.parse('https://www.sanativevibez.com/start-your-7-day-experience');
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')),
        );
      }
    }
  }

  Future<void> _saveReflection() async {
    if (_selectedChip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select how this prompt meets you today.')),
      );
      return;
    }

    final reflection = DailyReflection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      prompt: dailyPrompt,
      chipResponse: _selectedChip!,
      textResponse: _journalController.text,
    );

    await _storage.saveDailyReflection(reflection);
    
    setState(() {
      _isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isCompleted ? _buildCompletionState(colors, typography) : _buildPromptState(colors, typography),
        ),
      ),
    );
  }

  Widget _buildPromptState(ColorScheme colors, TextTheme typography) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Today\'s gentle prompt',
            style: typography.displaySmall?.copyWith(
              color: colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Today's Sanative Vibez Practice
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
                  'Today’s Sanative Vibez Practice',
                  style: typography.titleMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Take a moment for today\'s affirmation or reflection. If you are participating in the 7-Day Personal Practice, this app is here to accompany your experience.',
                  style: typography.bodyMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => _launchFrequenciesUrl(context),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.primary,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Learn about custom-created frequencies'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          
          // Prompt Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              dailyPrompt,
              style: typography.headlineSmall?.copyWith(
                color: colors.onPrimaryContainer,
                height: 1.4,
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Quick Check-in Response
          Text(
            'How does this prompt meet you today?',
            style: typography.titleMedium?.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _chipOptions.map((option) {
              final isSelected = _selectedChip == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedChip = selected ? option : null;
                  });
                },
                selectedColor: colors.primaryContainer,
                backgroundColor: colors.surface,
                labelStyle: typography.bodyMedium?.copyWith(
                  color: isSelected ? colors.onPrimaryContainer : colors.onSurface,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  side: BorderSide(
                    color: isSelected ? colors.primary : colors.outline.withValues(alpha: 0.2),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Optional Journal field
          TextField(
            controller: _journalController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write a few words, if you would like.',
              hintStyle: typography.bodyLarge?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: colors.outline.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: colors.outline.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: colors.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveReflection,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
              child: const Text('Save today\'s reflection'),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Affirmation Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.format_quote,
                  color: colors.secondary,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  dailyAffirmation,
                  textAlign: TextAlign.center,
                  style: typography.titleLarge?.copyWith(
                    color: colors.onSecondaryContainer,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionState(ColorScheme colors, TextTheme typography) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Icon(
              Icons.check_circle_outline,
              size: 64,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'You made space for yourself today.',
            textAlign: TextAlign.center,
            style: typography.displaySmall?.copyWith(
              color: colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Even a small pause can help you return to what matters.',
            textAlign: TextAlign.center,
            style: typography.bodyLarge?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.format_quote,
                  color: colors.secondary,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  dailyAffirmation,
                  textAlign: TextAlign.center,
                  style: typography.titleLarge?.copyWith(
                    color: colors.onSecondaryContainer,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
              child: const Text('Return to Home'),
            ),
          ),
        ],
      ),
    );
  }
}