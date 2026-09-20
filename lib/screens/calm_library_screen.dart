import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class CalmLibraryScreen extends StatelessWidget {
  const CalmLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    final practices = [
      {
        'category': 'Calm my body',
        'subtitle': 'Release tension and settle into your body.',
        'title': 'One-Minute Body Reset',
        'why': 'A few intentional movements can help you notice and soften physical tension.',
        'steps': [
          'Let your shoulders lower away from your ears.',
          'Unclench your jaw and relax your hands.',
          'Take three slow breaths, making your exhale a little longer than your inhale.',
        ],
        'completion': 'You gave your body a moment to soften.',
      },
      {
        'category': 'Slow racing thoughts',
        'subtitle': 'Create a little more space in your mind.',
        'title': 'Name What Is Here',
        'why': 'Putting simple words to the moment can create a little more space around it.',
        'steps': [
          'Notice one thought that keeps returning.',
          'Say silently: “I am noticing this thought.”',
          'Bring your attention back to one thing you can see right now.',
        ],
        'completion': 'You do not have to solve every thought at once.',
      },
      {
        'category': 'Lighten what feels heavy',
        'subtitle': 'Meet difficult moments with gentleness.',
        'title': 'Set Down One Thing',
        'why': 'Choosing one thing to release, even briefly, can make the next moment feel more manageable.',
        'steps': [
          'Name one thing that feels heavy.',
          'Ask: “Do I need to solve this in the next ten minutes?”',
          'If not, give yourself permission to set it down briefly.',
        ],
        'completion': 'You are allowed to carry one moment at a time.',
      },
      {
        'category': 'Find focus again',
        'subtitle': 'Return to one clear next step.',
        'title': 'Choose One Next Step',
        'why': 'A clear next step can help bring attention back to what is possible now.',
        'steps': [
          'Look at what is in front of you.',
          'Choose one task that takes less than ten minutes.',
          'Begin only that one task.',
        ],
        'completion': 'One small step is still movement forward.',
      },
      {
        'category': 'Restore my energy',
        'subtitle': 'Reset when your day feels draining.',
        'title': 'Gentle Energy Reset',
        'why': 'A short pause can help you reconnect with what might support you next.',
        'steps': [
          'Sit or stand in a comfortable position.',
          'Take one slow breath in and out.',
          'Ask yourself: “What would feel supportive in the next ten minutes?”',
        ],
        'completion': 'You are listening to what you need.',
      },
      {
        'category': 'Wind down',
        'subtitle': 'Create a softer ending to your day.',
        'title': 'Close the Day Gently',
        'why': 'A short closing practice can help you transition out of the day with more intention.',
        'steps': [
          'Name one thing you are ready to leave with today.',
          'Name one thing that supported you, even in a small way.',
          'Take one slow breath and let the day be complete for now.',
        ],
        'completion': 'You have permission to rest and begin again tomorrow.',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'What do you need right now?',
                style: typography.displaySmall?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Choose a small practice for the moment you are in.',
                style: typography.bodyLarge?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: practices.length,
                itemBuilder: (context, index) {
                  final practice = practices[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          context.push('/practice', extra: practice);
                        },
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                practice['category'] as String,
                                style: typography.titleLarge?.copyWith(
                                  color: colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                practice['subtitle'] as String,
                                style: typography.bodyMedium?.copyWith(
                                  color: colors.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> practice;

  const PracticeDetailScreen({super.key, required this.practice});

  @override
  State<PracticeDetailScreen> createState() => _PracticeDetailScreenState();
}

class _PracticeDetailScreenState extends State<PracticeDetailScreen> {
  Timer? _timer;
  int _timeLeft = 60;
  bool _isActive = false;
  bool _isFinished = false;

  void _startTimer() {
    setState(() {
      _isActive = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isFinished = true;
          _isActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    final String category = widget.practice['category'];
    final String title = widget.practice['title'];
    final String why = widget.practice['why'];
    final List<String> steps = List<String>.from(widget.practice['steps']);
    final String completion = widget.practice['completion'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.toUpperCase(),
                style: typography.labelMedium?.copyWith(
                  color: colors.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: typography.displaySmall?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                why,
                style: typography.bodyLarge?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Steps
              ...steps.asMap().entries.map((entry) {
                int idx = entry.key + 1;
                String stepText = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$idx',
                            style: typography.labelLarge?.copyWith(
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          stepText,
                          style: typography.bodyLarge?.copyWith(
                            color: colors.onSurface,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Actions & Timer State
              if (!_isActive && !_isFinished)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    ),
                    child: const Text('Begin this practice'),
                  ),
                )
              else if (_isActive)
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: _timeLeft / 60,
                              strokeWidth: 4,
                              backgroundColor: colors.outline.withValues(alpha: 0.2),
                              color: colors.primary,
                            ),
                          ),
                          Text(
                            '$_timeLeft',
                            style: typography.headlineMedium?.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Breathe...',
                        style: typography.bodyMedium?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: colors.primary,
                            size: 32,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            completion,
                            textAlign: TextAlign.center,
                            style: typography.titleLarge?.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
                
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}