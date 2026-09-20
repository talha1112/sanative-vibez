import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../services/storage_service.dart';

/// A single item in the reflection history timeline. Wraps either a
/// [CheckIn] or a [DailyReflection] so both can be shown in one
/// chronological, non-ordinal list.
class _HistoryItem {
  final DateTime date;
  final CheckIn? checkIn;
  final DailyReflection? reflection;

  _HistoryItem.fromCheckIn(this.checkIn)
      : date = checkIn!.date,
        reflection = null;

  _HistoryItem.fromReflection(this.reflection)
      : date = reflection!.date,
        checkIn = null;
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final StorageService _storage = StorageService();
  List<_HistoryItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final checkIns = await _storage.getCheckIns();
      final reflections = await _storage.getDailyReflections();

      final items = <_HistoryItem>[
        ...checkIns.map((c) => _HistoryItem.fromCheckIn(c)),
        ...reflections.map((r) => _HistoryItem.fromReflection(r)),
      ]..sort((a, b) => b.date.compareTo(a.date));

      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading reflection history: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: _items.isEmpty
              ? _buildEmptyState(colors, typography)
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Your reflection history',
                      style: typography.displaySmall?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'A personal record of your check-ins and reflections, in the order you made them.',
                      style: typography.bodyLarge?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    for (final item in _items) ...[
                      _HistoryCard(item: item),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    Center(
                      child: Text(
                        'Your reflections are a private space to notice what you may need.',
                        textAlign: TextAlign.center,
                        style: typography.bodyMedium?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colors, TextTheme typography) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_stories_outlined,
                      size: 56,
                      color: colors.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Your reflection history',
                      textAlign: TextAlign.center,
                      style: typography.displaySmall?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nothing here yet. As you check in and reflect, your entries will appear here in a simple, private timeline.',
                      textAlign: TextAlign.center,
                      style: typography.bodyLarge?.copyWith(
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
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final dateLabel = DateFormat('EEEE, MMMM d · h:mm a').format(item.date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.checkIn != null ? Icons.spa_outlined : Icons.wb_sunny_outlined,
                size: 18,
                color: colors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  dateLabel,
                  style: typography.labelMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (item.checkIn != null) ..._buildCheckIn(item.checkIn!, colors, typography),
          if (item.reflection != null) ..._buildReflection(item.reflection!, colors, typography),
        ],
      ),
    );
  }

  List<Widget> _buildCheckIn(CheckIn checkIn, ColorScheme colors, TextTheme typography) {
    return [
      Text(
        'Check-in: ${checkIn.stressLevel}',
        style: typography.titleMedium?.copyWith(color: colors.onSurface),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        'What would support you: ${checkIn.supportNeeded}',
        style: typography.bodyMedium?.copyWith(
          color: colors.onSurface.withValues(alpha: 0.75),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        'Intention: ${checkIn.intention}',
        style: typography.bodyMedium?.copyWith(
          color: colors.onSurface.withValues(alpha: 0.75),
        ),
      ),
    ];
  }

  List<Widget> _buildReflection(DailyReflection reflection, ColorScheme colors, TextTheme typography) {
    return [
      Text(
        reflection.prompt,
        style: typography.titleMedium?.copyWith(color: colors.onSurface),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        reflection.chipResponse,
        style: typography.bodyMedium?.copyWith(
          color: colors.onSurface.withValues(alpha: 0.75),
        ),
      ),
      if (reflection.textResponse.trim().isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          '"${reflection.textResponse.trim()}"',
          style: typography.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.85),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ];
  }
}
