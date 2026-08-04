import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/utils/relationship_calculator.dart';
import '../models/display_format.dart';

/// Large centered display of the total days together, with an animated
/// fade/scale transition whenever the count changes. Tapping cycles through
/// [DisplayFormat]s (days / years+months+days / weeks+days).
class DayCounter extends StatelessWidget {
  const DayCounter({
    super.key,
    required this.stats,
    required this.format,
    required this.startDate,
    required this.onTap,
    this.onDateLongPress,
  });

  final RelationshipStats stats;
  final DisplayFormat format;
  final DateTime startDate;
  final VoidCallback onTap;
  final VoidCallback? onDateLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedCount = RelationshipCalculator.formatCount(stats, format);
    final formattedStart = DateFormat.yMMMMd().format(startDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Together for',
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: Text(
                formattedCount,
                key: ValueKey(formattedCount),
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontWeight: FontWeight.w700,
                  fontSize: 52,
                  height: 1.1,
                  letterSpacing: -0.5,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onLongPress: onDateLongPress,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Since $formattedStart',
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
