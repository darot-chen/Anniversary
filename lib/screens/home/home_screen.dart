import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/edit_dialogs.dart';
import '../../core/utils/relationship_calculator.dart';
import '../../providers/relationship_stats_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/anniversary_bar.dart';
import '../../widgets/day_counter.dart';
import '../../widgets/profile_photos_row.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final stats = ref.watch(relationshipStatsProvider);
    final anniversaryBarStats = RelationshipCalculator.anniversaryBar(
      settings.startDate,
      settings.displayFormat,
    );
    final notifier = ref.read(settingsProvider.notifier);

    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final hasBackground = settings.backgroundImagePath != null;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onLongPress: () => notifier.pickBackgroundImage(),
              child: hasBackground
                  ? Image.file(
                      File(settings.backgroundImagePath!),
                      fit: BoxFit.cover,
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.tertiary,
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: topInset + 8,
            right: 12,
            child: _SettingsButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, bottomInset + 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProfilePhotosRow(
                    userPhotoPath: settings.userPhotoPath,
                    partnerPhotoPath: settings.partnerPhotoPath,
                    userName: settings.userName,
                    partnerName: settings.partnerName,
                    onUserPhotoLongPress: () => notifier.pickUserPhoto(),
                    onPartnerPhotoLongPress: () => notifier.pickPartnerPhoto(),
                    onUserNameLongPress: () => showEditTextDialog(
                      context,
                      title: 'Your Name',
                      currentValue: settings.userName,
                      onSave: notifier.updateUserName,
                    ),
                    onPartnerNameLongPress: () => showEditTextDialog(
                      context,
                      title: 'Partner Name',
                      currentValue: settings.partnerName,
                      onSave: notifier.updatePartnerName,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 12),
                        child: child,
                      ),
                    ),
                    child: DayCounter(
                      stats: stats,
                      format: settings.displayFormat,
                      startDate: settings.startDate,
                      onTap: () => notifier.cycleDisplayFormat(),
                      onDateLongPress: () => showEditStartDateDialog(
                        context,
                        currentValue: settings.startDate,
                        onSave: notifier.updateStartDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnniversaryBar(stats: anniversaryBarStats),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.settings_outlined, color: Colors.white),
        tooltip: 'Settings',
        onPressed: onPressed,
      ),
    );
  }
}
