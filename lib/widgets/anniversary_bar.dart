import 'package:flutter/material.dart';

import '../core/utils/relationship_calculator.dart';

/// Classic progress bar toward the current milestone bucket (e.g.
/// 600 -> 700 days, or 2Y -> 3Y), with a "♥ D-N left" caption above it and
/// the bucket's start/end labels below.
class AnniversaryBar extends StatelessWidget {
  const AnniversaryBar({super.key, required this.stats});

  final AnniversaryBarStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = stats.progress.clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('❤️', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              stats.remainingDays == 0
                  ? 'Today!'
                  : 'D-${stats.remainingDays} left',
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              stats.startLabel,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress == 0 ? 0.03 : progress,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.tertiary,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              stats.endLabel,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
