import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../services/storage_service.dart';

enum CheckInStep { feeling, support, intention, result }

class CheckInFlowScreen extends StatefulWidget {
  final String? initialFeeling;
  const CheckInFlowScreen({super.key, this.initialFeeling});

  @override
  State<CheckInFlowScreen> createState() => _CheckInFlowScreenState();
}

class _CheckInFlowScreenState extends State<CheckInFlowScreen> {
  final PageController _pageController = PageController();
  final StorageService _storage = StorageService();

  String? _selectedFeeling;
  String? _selectedSupport;
  String? _selectedIntention;

  late List<CheckInStep> _steps;

  @override
  void initState() {
    super.initState();
    _selectedFeeling = widget.initialFeeling;
    _steps = [
      if (_selectedFeeling == null) CheckInStep.feeling,
      CheckInStep.support,
      CheckInStep.intention,
      CheckInStep.result,
    ];
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishCheckIn() async {
    if (_selectedFeeling == null || _selectedSupport == null || _selectedIntention == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final checkIn = CheckIn(
      id: id,
      date: DateTime.now(),
      stressLevel: _selectedFeeling!,
      supportNeeded: _selectedSupport!,
      intention: _selectedIntention!,
    );

    await _storage.saveCheckIn(checkIn);

    if (mounted) {
      _nextPage();
    }
  }

  Widget _buildStep(CheckInStep step) {
    switch (step) {
      case CheckInStep.feeling:
        return _StepFeeling(
          onSelected: (val) {
            setState(() => _selectedFeeling = val);
            _nextPage();
          },
        );
      case CheckInStep.support:
        return _StepSupport(
          onSelected: (val) {
            setState(() => _selectedSupport = val);
            _nextPage();
          },
        );
      case CheckInStep.intention:
        return _StepIntention(
          onSelected: (val) {
            setState(() => _selectedIntention = val);
            _finishCheckIn();
          },
        );
      case CheckInStep.result:
        return _ResultScreen(
          feeling: _selectedFeeling ?? 'Grounded',
          supportNeeded: _selectedSupport ?? 'quiet_moment',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to force tap choice
        children: _steps.map(_buildStep).toList(),
      ),
    );
  }
}

class _StepFeeling extends StatelessWidget {
  final Function(String) onSelected;

  const _StepFeeling({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling right now?',
              style: typography.displaySmall?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: ListView(
                children: [
                  _OptionCard(
                    title: 'Grounded',
                    subtitle: 'I feel mostly steady.',
                    onTap: () => onSelected('Grounded'),
                  ),
                  _OptionCard(
                    title: 'Full',
                    subtitle: 'I have a lot on my mind.',
                    onTap: () => onSelected('Full'),
                  ),
                  _OptionCard(
                    title: 'Weary',
                    subtitle: 'I could use a pause.',
                    onTap: () => onSelected('Weary'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepSupport extends StatelessWidget {
  final Function(String) onSelected;

  const _StepSupport({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final options = [
      {'id': 'quiet_moment', 'label': 'A quiet moment'},
      {'id': 'clearer_thoughts', 'label': 'Clearer thoughts'},
      {'id': 'more_energy', 'label': 'More energy'},
      {'id': 'emotional_release', 'label': 'Letting something go'},
      {'id': 'better_rest', 'label': 'Better rest'},
      {'id': 'not_sure', 'label': 'I am not sure'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What would support you most right now?',
              style: typography.displaySmall?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return _OptionCard(
                    title: option['label']!,
                    onTap: () => onSelected(option['id']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIntention extends StatelessWidget {
  final Function(String) onSelected;

  const _StepIntention({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final options = [
      'Slow down',
      'Be kind to myself',
      'Focus on one next step',
      'Release what I cannot control',
      'Make space to breathe',
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a gentle intention for today.',
              style: typography.displaySmall?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return _OptionCard(
                    title: options[index],
                    onTap: () => onSelected(options[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
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
                title,
                style: typography.titleLarge?.copyWith(
                  color: colors.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: typography.bodyMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultExperience {
  final String id;
  final String title;
  final String reflection;
  final String action;
  final String affirmation;
  final String ctaLabel;
  final String practiceTitle;
  final Map<String, dynamic> practiceData;

  const _ResultExperience({
    required this.id,
    required this.title,
    required this.reflection,
    required this.action,
    required this.affirmation,
    required this.ctaLabel,
    required this.practiceTitle,
    required this.practiceData,
  });
}

/// Practice libraries keyed by feeling category. Each entry has a stable
/// [_ResultExperience.id] so the initial pick and "show me another" cycling
/// can be driven by explicit id lookups rather than list position.
const Map<String, List<_ResultExperience>> _experienceLibrary = {
  'Grounded': [
    _ResultExperience(
      id: 'grounded_body_reset',
      title: 'Settle into your body.',
      reflection: 'Your system has a little room today. Let your body notice it before the day speeds up.',
      action: 'Relax your shoulders, unclench your jaw, and slowly roll your neck once in each direction.',
      affirmation: 'I can make space for ease in my body.',
      ctaLabel: 'Start: One-Minute Body Reset',
      practiceTitle: 'One-Minute Body Reset',
      practiceData: {
        'category': 'body release',
        'title': 'One-Minute Body Reset',
        'subtitle': 'Settle into your body.',
        'why': 'Your system has a little room today. Let your body notice it before the day speeds up.',
        'steps': [
          'Relax your shoulders.',
          'Unclench your jaw.',
          'Slowly roll your neck once in each direction.',
        ],
        'completion': 'You have made space for ease in your body.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'grounded_sensory_pause',
      title: 'Notice what is here.',
      reflection: 'A small moment of noticing can make an ordinary day feel more spacious.',
      action: 'Find three details around you that feel pleasant: a color, a texture, and a sound.',
      affirmation: 'I am here for this moment.',
      ctaLabel: 'Start: One-Minute Sensory Pause',
      practiceTitle: 'One-Minute Sensory Pause',
      practiceData: {
        'category': 'sensory grounding',
        'title': 'One-Minute Sensory Pause',
        'subtitle': 'Notice what is here.',
        'why': 'A small moment of noticing can make an ordinary day feel more spacious.',
        'steps': [
          'Find a color around you that feels pleasant.',
          'Find a texture around you that feels pleasant.',
          'Find a sound around you that feels pleasant.',
        ],
        'completion': 'You are here for this moment.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'grounded_gentle_movement',
      title: 'Let your energy move.',
      reflection: 'Lightness can be carried forward through a little movement, not more effort.',
      action: 'Stand up, stretch toward the ceiling, then take ten easy steps.',
      affirmation: 'I move through today with ease.',
      ctaLabel: 'Start: One-Minute Gentle Movement',
      practiceTitle: 'One-Minute Gentle Movement',
      practiceData: {
        'category': 'movement',
        'title': 'One-Minute Gentle Movement',
        'subtitle': 'Let your energy move.',
        'why': 'Lightness can be carried forward through a little movement, not more effort.',
        'steps': [
          'Stand up.',
          'Stretch toward the ceiling.',
          'Take ten easy steps.',
        ],
        'completion': 'You move through today with ease.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'grounded_savor',
      title: 'Let the good land.',
      reflection: 'You do not have to rush past a moment that feels manageable. Let it register.',
      action: 'Name one thing that is going okay right now, and stay with it for three breaths.',
      affirmation: 'I let good moments count.',
      ctaLabel: 'Start: One-Minute Savoring Practice',
      practiceTitle: 'One-Minute Savoring Practice',
      practiceData: {
        'category': 'positive reflection',
        'title': 'One-Minute Savoring Practice',
        'subtitle': 'Let the good land.',
        'why': 'You do not have to rush past a moment that feels manageable. Let it register.',
        'steps': [
          'Name one thing that is going okay right now.',
          'Take a deep breath and stay with it.',
          'Take two more slow breaths, letting it register.',
        ],
        'completion': 'You let good moments count.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'grounded_connection',
      title: 'Share a little warmth.',
      reflection: 'A small connection can extend the steadiness you already feel.',
      action: 'Send one simple message of appreciation, encouragement, or care.',
      affirmation: 'I can offer warmth without losing myself.',
      ctaLabel: 'Start: One-Minute Connection Prompt',
      practiceTitle: 'One-Minute Connection Prompt',
      practiceData: {
        'category': 'connection',
        'title': 'One-Minute Connection Prompt',
        'subtitle': 'Share a little warmth.',
        'why': 'A small connection can extend the steadiness you already feel.',
        'steps': [
          'Think of someone you appreciate.',
          'Draft a simple message of appreciation, encouragement, or care.',
          'Send the message and notice how you feel.',
        ],
        'completion': 'You have offered warmth without losing yourself.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'grounded_play',
      title: 'Choose a small delight.',
      reflection: 'You are allowed to add a little brightness to an ordinary day.',
      action: 'Choose one tiny thing that feels enjoyable: a favorite song, fresh air, or a sip of something you like.',
      affirmation: 'Joy is welcome in my day.',
      ctaLabel: 'Start: One-Minute Delight Practice',
      practiceTitle: 'One-Minute Delight Practice',
      practiceData: {
        'category': 'delight',
        'title': 'One-Minute Delight Practice',
        'subtitle': 'Choose a small delight.',
        'why': 'You are allowed to add a little brightness to an ordinary day.',
        'steps': [
          'Think of one tiny thing that feels enjoyable right now.',
          'Give yourself permission to experience it.',
          'Enjoy it fully without rushing.',
        ],
        'completion': 'Joy is welcome in your day.',
        'duration': 60,
      },
    ),
  ],
  'Full': [
    _ResultExperience(
      id: 'full_tension_release',
      title: 'Releasing Stored Tension',
      reflection: 'Tension often settles into our muscles before we consciously notice it. Releasing it physically can help the mind follow.',
      action: 'Actively soften the physical grip of a busy mind.',
      affirmation: 'I am allowed to soften and let go of the pressure.',
      ctaLabel: 'Start: Targeted Tension Release',
      practiceTitle: 'Targeted Tension Release',
      practiceData: {
        'category': 'Body release',
        'title': 'Targeted Tension Release',
        'subtitle': 'Let go of physical bracing.',
        'why': 'Your body often holds onto tension without you noticing; softening your muscles can help you feel more at ease.',
        'steps': [
          'Scan your body for tightness, starting with your jaw.',
          'Intentionally unclench your teeth and drop your shoulders.',
          'Take a breath and let your hands soften completely.',
        ],
        'completion': 'You have released some of the physical pressure.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'full_grounding',
      title: 'Finding Your Footing',
      reflection: 'When your mind is full, it can feel like you are spinning. Reconnecting with the physical world gives you a stable foundation.',
      action: 'Anchor yourself in your physical surroundings.',
      affirmation: 'I am supported, safe, and right here.',
      ctaLabel: 'Start: Physical Grounding',
      practiceTitle: 'Physical Grounding',
      practiceData: {
        'category': 'Grounding',
        'title': 'Physical Grounding',
        'subtitle': 'Establish a stable foundation.',
        'why': 'Feeling gravity and physical support can help quiet a busy mind.',
        'steps': [
          'Press both feet firmly into the floor.',
          'Notice the solid support of the chair or ground beneath you.',
          'Shift your weight slightly to feel gravity holding you in place.',
        ],
        'completion': 'You have anchored yourself in the present.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'full_sensory_reset',
      title: 'Clearing the Mental Clutter',
      reflection: 'A busy mind can feel loud. Engaging your senses provides an immediate off-ramp for racing thoughts.',
      action: 'Use your senses to step out of the noise.',
      affirmation: 'I can step away from my thoughts and into the present.',
      ctaLabel: 'Start: 3-2-1 Sensory Reset',
      practiceTitle: '3-2-1 Sensory Reset',
      practiceData: {
        'category': 'Sensory reset',
        'title': '3-2-1 Sensory Reset',
        'subtitle': 'Interrupt the cycle of overthinking.',
        'why': 'Shifting focus to external senses can interrupt a loop of overthinking.',
        'steps': [
          'Name 3 things you can clearly see in the room.',
          'Touch 2 objects and notice their texture or temperature.',
          'Listen closely for 1 distinct sound around you.',
        ],
        'completion': 'You have successfully stepped out of the noise.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'full_paced_breath',
      title: 'Slowing Down the Rhythm',
      reflection: 'Everything can feel urgent when you\'re carrying a lot. Slowing your breath, on purpose, is one way to remind yourself there is no emergency.',
      action: 'Find your rhythm again with a paced breath.',
      affirmation: 'I do not have to rush. I am pacing myself.',
      ctaLabel: 'Start: Box Breathing Pause',
      practiceTitle: 'Box Breathing Pause',
      practiceData: {
        'category': 'Breath',
        'title': 'Box Breathing Pause',
        'subtitle': 'Regain your natural rhythm.',
        'why': 'Paced breathing is a simple way to slow down and ease a sense of urgency.',
        'steps': [
          'Inhale slowly for four seconds.',
          'Hold that breath gently for four seconds.',
          'Exhale for four seconds, and pause before breathing in again.',
        ],
        'completion': 'You are beginning to settle.',
        'duration': 60,
      },
    ),
  ],
  'Weary': [
    _ResultExperience(
      id: 'weary_compassionate_pause',
      title: 'Permission to Not Be Okay',
      reflection: 'You are carrying a heavy load right now. You do not have to fix everything in this moment; it is enough to just breathe.',
      action: 'Meet yourself with gentleness instead of expectations.',
      affirmation: 'I am doing the best I can, and that is enough.',
      ctaLabel: 'Start: Compassionate Pause',
      practiceTitle: 'Compassionate Pause',
      practiceData: {
        'category': 'Self-compassion',
        'title': 'Compassionate Pause',
        'subtitle': 'Drop the need to fix anything right now.',
        'why': 'Expecting yourself to fix everything at once only adds pressure. Gentleness is the first step to relief.',
        'steps': [
          'Place a hand gently over your heart or stomach.',
          'Acknowledge to yourself that this is a difficult moment.',
          'Breathe softly, without trying to change how you feel.',
        ],
        'completion': 'You have met yourself with the kindness you deserve.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'weary_safe_object',
      title: 'Anchoring in the Now',
      reflection: 'When everything feels like too much, the future is too big to look at. Let\'s bring everything down to this exact second.',
      action: 'Focus only on the physical reality of right now.',
      affirmation: 'I am safe in this exact moment.',
      ctaLabel: 'Start: One Safe Object',
      practiceTitle: 'One Safe Object',
      practiceData: {
        'category': 'Grounding',
        'title': 'One Safe Object',
        'subtitle': 'Find safety in a single point of focus.',
        'why': 'Narrowing your focus to one physical object can help ease a spiral of worst-case thinking.',
        'steps': [
          'Find one object near you that looks comforting or neutral.',
          'Hold it or focus your eyes on it completely.',
          'Notice its color, weight, and shape for a few slow breaths.',
        ],
        'completion': 'You have anchored yourself safely in the present.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'weary_mental_drop',
      title: 'Dropping the Weight',
      reflection: 'When you\'re weary, everything can feel important and urgent. Right now, almost everything can wait. Let\'s set it down.',
      action: 'Consciously decide to stop carrying it all.',
      affirmation: 'I give myself permission to stop and rest.',
      ctaLabel: 'Start: The Mental Drop',
      practiceTitle: 'The Mental Drop',
      practiceData: {
        'category': 'Boundaries',
        'title': 'The Mental Drop',
        'subtitle': 'Visualize putting down the heavy burden.',
        'why': 'When you\'re overwhelmed, your mind needs explicit permission to stop holding onto everything at once.',
        'steps': [
          'Imagine all your worries as heavy bags in your hands.',
          'Visualize yourself physically dropping them onto the floor.',
          'Tell yourself: "They will be there later, but not right now."',
        ],
        'completion': 'You have set down what you cannot carry.',
        'duration': 60,
      },
    ),
    _ResultExperience(
      id: 'weary_heavy_exhale',
      title: 'Softening the Armor',
      reflection: 'Your body has been bracing for impact. A tiny moment of letting go can help prevent further exhaustion.',
      action: 'Allow your body to stop fighting for a minute.',
      affirmation: 'I can let my guard down safely for one minute.',
      ctaLabel: 'Start: The Heavy Exhale',
      practiceTitle: 'The Heavy Exhale',
      practiceData: {
        'category': 'Body release',
        'title': 'The Heavy Exhale',
        'subtitle': 'Give your body a moment of relief.',
        'why': 'A deep, audible exhale is a simple way to help your body soften when everything feels like too much.',
        'steps': [
          'Take a deep breath in, filling your lungs completely.',
          'Open your mouth and sigh the air out loudly.',
          'Repeat this twice, letting your shoulders droop with each exhale.',
        ],
        'completion': 'Your body has received a moment of relief.',
        'duration': 60,
      },
    ),
  ],
};

/// Which practice id a given support choice should surface first, per feeling category.
const Map<String, Map<String, String>> _initialPickByFeeling = {
  'Grounded': {
    'quiet_moment': 'grounded_sensory_pause',
    'clearer_thoughts': 'grounded_body_reset',
    'more_energy': 'grounded_gentle_movement',
    'emotional_release': 'grounded_connection',
    'better_rest': 'grounded_savor',
    'not_sure': 'grounded_play',
  },
  'Full': {
    'quiet_moment': 'full_grounding',
    'clearer_thoughts': 'full_sensory_reset',
    'more_energy': 'full_paced_breath',
    'emotional_release': 'full_tension_release',
    'better_rest': 'full_tension_release',
    'not_sure': 'full_tension_release',
  },
  'Weary': {
    'quiet_moment': 'weary_mental_drop',
    'clearer_thoughts': 'weary_safe_object',
    'more_energy': 'weary_heavy_exhale',
    'emotional_release': 'weary_compassionate_pause',
    'better_rest': 'weary_mental_drop',
    'not_sure': 'weary_compassionate_pause',
  },
};

class _ResultScreen extends StatefulWidget {
  final String feeling;
  final String supportNeeded;

  const _ResultScreen({required this.feeling, required this.supportNeeded});

  @override
  State<_ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<_ResultScreen> {
  late final List<_ResultExperience> _experiences;
  late String _activeId;
  late final List<String> _shownIds;

  @override
  void initState() {
    super.initState();

    _experiences = _experienceLibrary[widget.feeling] ?? _experienceLibrary['Grounded']!;

    final pickMap = _initialPickByFeeling[widget.feeling] ?? _initialPickByFeeling['Grounded']!;
    final initialId = pickMap[widget.supportNeeded] ?? _experiences.first.id;

    _activeId = _experiences.any((e) => e.id == initialId) ? initialId : _experiences.first.id;
    _shownIds = [_activeId];
  }

  _ResultExperience get _activeExperience =>
      _experiences.firstWhere((e) => e.id == _activeId, orElse: () => _experiences.first);

  bool get _hasMoreOptions => _shownIds.length < _experiences.length;

  void _showNextOption() {
    setState(() {
      final remaining = _experiences.map((e) => e.id).where((id) => !_shownIds.contains(id)).toList();
      if (remaining.isNotEmpty) {
        _activeId = remaining.first;
        _shownIds.add(_activeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final experience = _activeExperience;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              experience.title,
              style: typography.displaySmall?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),

            _ResultSection(
              title: 'Reflection',
              content: experience.reflection,
              icon: Icons.auto_awesome,
            ),
            const SizedBox(height: AppSpacing.lg),

            _ResultSection(
              title: 'Suggested Action',
              content: experience.action,
              icon: Icons.pan_tool_alt,
            ),
            const SizedBox(height: AppSpacing.lg),

            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  Icon(Icons.format_quote, color: colors.secondary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    experience.affirmation,
                    textAlign: TextAlign.center,
                    style: typography.titleLarge?.copyWith(
                      color: colors.onSecondaryContainer,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => _InlinePracticeScreen(practice: experience.practiceData),
                    ),
                  );
                },
                child: Text(experience.ctaLabel),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            if (_hasMoreOptions)
              Center(
                child: TextButton(
                  onPressed: _showNextOption,
                  child: const Text('Show me another option'),
                ),
              )
            else
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Start a new check-in'),
                ),
              ),

            const SizedBox(height: AppSpacing.md),

            Text(
              'Sanative Vibez is a non-clinical space for personal reflection, not medical care, psychotherapy, diagnosis, or treatment. If you feel unsafe or need urgent support, contact local emergency services or a qualified professional.',
              style: typography.bodySmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _ResultSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colors.primary, size: 24),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: typography.labelLarge?.copyWith(
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                content,
                style: typography.bodyLarge?.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InlinePracticeScreen extends StatefulWidget {
  final Map<String, dynamic> practice;

  const _InlinePracticeScreen({Key? key, required this.practice}) : super(key: key);

  @override
  State<_InlinePracticeScreen> createState() => _InlinePracticeScreenState();
}

class _InlinePracticeScreenState extends State<_InlinePracticeScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final steps = widget.practice['steps'] as List<String>;
    final isFinished = _currentStep >= steps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.practice['title']),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.practice['subtitle'],
                style: typography.titleMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.practice['why'],
                style: typography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: isFinished
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, size: 64, color: colors.primary),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              widget.practice['completion'],
                              style: typography.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Step ${_currentStep + 1} of ${steps.length}',
                            style: typography.labelLarge?.copyWith(color: colors.primary),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            steps[_currentStep],
                            style: typography.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  if (isFinished) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _currentStep++;
                    });
                  }
                },
                child: Text(isFinished ? 'Finish' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
