import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/visitor_tracker.dart';

/// A footer-style section that displays a page visit counter
/// with an option to view a bar chart of daily visits over time.
class VisitorCounterSection extends StatefulWidget {
  const VisitorCounterSection({super.key});

  @override
  State<VisitorCounterSection> createState() => _VisitorCounterSectionState();
}

class _VisitorCounterSectionState extends State<VisitorCounterSection> {
  final VisitorTracker _tracker = VisitorTracker();
  int _totalVisits = 0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initTracker();
  }

  Future<void> _initTracker() async {
    await _tracker.recordVisit();
    final total = await _tracker.getTotalVisits();
    if (mounted) {
      setState(() {
        _totalVisits = total;
        _isLoaded = true;
      });
    }
  }

  void _showVisitorChart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const VisitorChartDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Divider(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _isLoaded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: InkWell(
                  onTap: () => _showVisitorChart(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_totalVisits page ${_totalVisits == 1 ? 'visit' : 'visits'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.bar_chart_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog that displays a bar chart of daily page visits.
class VisitorChartDialog extends StatefulWidget {
  const VisitorChartDialog({super.key});

  @override
  State<VisitorChartDialog> createState() => _VisitorChartDialogState();
}

class _VisitorChartDialogState extends State<VisitorChartDialog> {
  final VisitorTracker _tracker = VisitorTracker();
  Map<String, int> _dailyVisits = {};
  int _totalVisits = 0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final daily = await _tracker.getDailyVisits(days: 30);
    final total = await _tracker.getTotalVisits();
    if (mounted) {
      setState(() {
        _dailyVisits = daily;
        _totalVisits = total;
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 900;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 700 : screenWidth * 0.95,
          maxHeight: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Page Visit Statistics',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tracked from this browser · Last 30 days',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatCards(theme),
              const SizedBox(height: 24),
              Text(
                'Daily Visits',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: _isLoaded
                    ? _buildChart(theme)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards(ThemeData theme) {
    final visitsThisPeriod =
        _dailyVisits.values.fold<int>(0, (sum, v) => sum + v);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Visits',
            value: '$_totalVisits',
            icon: Icons.visibility,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Last 30 Days',
            value: '$visitsThisPeriod',
            icon: Icons.calendar_month,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(ThemeData theme) {
    final entries = _dailyVisits.entries.toList();
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No visit data yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final maxY = entries
        .map((e) => e.value.toDouble())
        .reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxY < 1) ? 1.0 : maxY + 1;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: chartMaxY,
          minY: 0,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final entry = entries[group.x.toInt()];
                final dateParts = entry.key.split('-');
                final label =
                    '${dateParts[1]}/${dateParts[2]}';
                return BarTooltipItem(
                  '$label\n${rod.toY.toInt()} visit${rod.toY.toInt() == 1 ? '' : 's'}',
                  TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= entries.length) {
                    return const SizedBox.shrink();
                  }
                  // Show label every 7 days
                  if (index % 7 != 0 && index != entries.length - 1) {
                    return const SizedBox.shrink();
                  }
                  final dateParts = entries[index].key.split('-');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${dateParts[1]}/${dateParts[2]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value != value.roundToDouble()) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    value.toInt().toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          barGroups: List.generate(entries.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entries[index].value.toDouble(),
                  color: entries[index].value > 0
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: entries.length > 14 ? 4 : 8,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
