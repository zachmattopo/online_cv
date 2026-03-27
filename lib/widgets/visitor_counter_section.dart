import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A footer section that displays a visitor counter badge and a link to view
/// visitor statistics over time. Uses visitorbadge.io — a free, zero-config
/// service that increments a counter every time the badge image is loaded.
class VisitorCounterSection extends StatelessWidget {
  const VisitorCounterSection({super.key});

  static const String _pagePath =
      'https%3A%2F%2Fzachmattopo.github.io%2Fonline-cv-live%2F';

  static const String _badgeUrl =
      'https://api.visitorbadge.io/api/visitors'
      '?path=$_pagePath'
      '&label=Page%20Visits'
      '&countColor=%230284c7';

  static const String _statusUrl =
      'https://api.visitorbadge.io/api/status'
      '?path=$_pagePath';

  Future<void> _openStats() async {
    final uri = Uri.parse(_statusUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visitor counter badge — loading this image registers a visit
          Image.network(
            _badgeUrl,
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'Visitor counter unavailable',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _openStats,
            icon: Icon(
              Icons.bar_chart_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            label: Text(
              'View visitor statistics',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
