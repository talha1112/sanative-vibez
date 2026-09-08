import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../services/storage_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final StorageService _storage = StorageService();
  List<CheckIn> _checkIns = [];
  bool _isLoading = true;
  String _selectedFilter = '7 days';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _storage.getCheckIns();
      if (mounted) {
        setState(() {
          _checkIns = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading insights data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<CheckIn> get _filteredCheckIns {
    final now = DateTime.now();
    if (_selectedFilter == '7 days') {
      return _checkIns.where((c) => now.difference(c.date).inDays <= 7).toList();
    } else if (_selectedFilter == '30 days') {
      return _checkIns.where((c) => now.difference(c.date).inDays <= 30).toList();
    }
    return _checkIns; // All time
  }

  String get _mostCommonStressLevel {
    if (_filteredCheckIns.isEmpty) return 'No data';
    final Map<String, int> counts = {};
    for (var c in _filteredCheckIns) {
      counts[c.stressLevel] = (counts[c.stressLevel] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredData = _filteredCheckIns;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your insights',
                style: typography.displaySmall?.copyWith(
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Notice your patterns with curiosity, not judgment.',
                style: typography.bodyLarge?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Filters
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: '7 days', label: Text('7 days')),
                  ButtonSegment(value: '30 days', label: Text('30 days')),
                  ButtonSegment(value: 'All time', label: Text('All time')),
                ],
                selected: {_selectedFilter},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedFilter = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return colors.primaryContainer;
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total Check-ins',
                      value: filteredData.length.toString(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Most Common Check-in',
                      value: _mostCommonStressLevel,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              if (filteredData.isNotEmpty)
                _StatCard(
                  title: 'Most Recent',
                  value: DateFormat('MMM d, yyyy - h:mm a').format(filteredData.first.date),
                ),

              const SizedBox(height: AppSpacing.xl),
              
              // Chart
              if (filteredData.isNotEmpty)
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: colors.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: _buildChart(filteredData, colors),
                ),
              
              const SizedBox(height: AppSpacing.xl),
              
              Center(
                child: Text(
                  'Your check-ins are a private space to notice what you may need.',
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

  Widget _buildChart(List<CheckIn> data, ColorScheme colors) {
    // Non-ordinal frequency view: how many times each feeling was chosen.
    // Deliberately not a trend/severity line — there is no "higher = worse" axis.
    const feelings = ['Grounded', 'Full', 'Weary'];
    final Map<String, int> counts = {for (final f in feelings) f: 0};
    for (final c in data) {
      if (counts.containsKey(c.stressLevel)) {
        counts[c.stressLevel] = counts[c.stressLevel]! + 1;
      }
    }

    final maxCount = counts.values.fold<int>(0, (a, b) => a > b ? a : b);
    final chartMax = maxCount == 0 ? 1.0 : maxCount.toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: chartMax + (chartMax * 0.2),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colors.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                if (value != value.roundToDouble()) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= feelings.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    feelings[index],
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 0; i < feelings.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: counts[feelings[i]]!.toDouble(),
                  color: colors.primary,
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: typography.labelMedium?.copyWith(
              color: colors.onSecondaryContainer.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: typography.titleLarge?.copyWith(
              color: colors.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
