import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/utils/edit_dialogs.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _pickReminderTime(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: settings.reminderTime,
    );
    if (picked != null) {
      await ref.read(settingsProvider.notifier).updateReminderTime(picked);
    }
  }

  Future<void> _pickThemeMode(BuildContext context, WidgetRef ref) async {
    final current = ref.read(settingsProvider).themeMode;
    final picked = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in ThemeMode.values)
              ListTile(
                title: Text(_themeModeLabel(mode)),
                trailing: mode == current
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.of(context).pop(mode),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      await ref.read(settingsProvider.notifier).updateThemeMode(picked);
    }
  }

  Widget _photoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String? path,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: path != null
            ? Image.file(
                File(path),
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              )
            : Container(
                width: 44,
                height: 44,
                color: theme.colorScheme.surfaceContainerHigh,
                child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
              ),
      ),
      title: Text(title),
      subtitle: Text(path != null ? 'Tap to change' : 'Not set'),
      trailing: path != null
          ? IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Remove',
              onPressed: onClear,
            )
          : null,
      onTap: onPick,
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader('Relationship'),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Anniversary Date'),
            subtitle: Text(DateFormat.yMMMMd().format(settings.startDate)),
            onTap: () => showEditStartDateDialog(
              context,
              currentValue: settings.startDate,
              onSave: (value) =>
                  ref.read(settingsProvider.notifier).updateStartDate(value),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Your Name'),
            subtitle: Text(
              settings.userName.isEmpty ? 'Not set' : settings.userName,
            ),
            onTap: () => showEditTextDialog(
              context,
              title: 'Your Name',
              currentValue: settings.userName,
              onSave: (value) =>
                  ref.read(settingsProvider.notifier).updateUserName(value),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Partner Name'),
            subtitle: Text(
              settings.partnerName.isEmpty ? 'Not set' : settings.partnerName,
            ),
            onTap: () => showEditTextDialog(
              context,
              title: 'Partner Name',
              currentValue: settings.partnerName,
              onSave: (value) => ref
                  .read(settingsProvider.notifier)
                  .updatePartnerName(value),
            ),
          ),
          const Divider(height: 24),
          _SectionHeader('Reminder'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Daily Reminder'),
            value: settings.reminderEnabled,
            onChanged: (value) =>
                ref.read(settingsProvider.notifier).setReminderEnabled(value),
          ),
          ListTile(
            leading: const Icon(Icons.schedule_outlined),
            title: const Text('Reminder Time'),
            subtitle: Text(settings.reminderTime.format(context)),
            enabled: settings.reminderEnabled,
            onTap: () => _pickReminderTime(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text('Reminder Message'),
            subtitle: Text(settings.reminderMessage),
            enabled: settings.reminderEnabled,
            onTap: () => showEditTextDialog(
              context,
              title: 'Reminder Message',
              currentValue: settings.reminderMessage,
              hintText: "Don't forget to say good night.",
              maxLines: 2,
              onSave: (value) {
                if (value.isNotEmpty) {
                  ref
                      .read(settingsProvider.notifier)
                      .updateReminderMessage(value);
                }
              },
            ),
          ),
          const Divider(height: 24),
          _SectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeModeLabel(settings.themeMode)),
            onTap: () => _pickThemeMode(context, ref),
          ),
          const Divider(height: 24),
          _SectionHeader('Photos'),
          _photoTile(
            context,
            icon: Icons.wallpaper_outlined,
            title: 'Background Image',
            path: settings.backgroundImagePath,
            onPick: () =>
                ref.read(settingsProvider.notifier).pickBackgroundImage(),
            onClear: () =>
                ref.read(settingsProvider.notifier).clearBackgroundImage(),
          ),
          _photoTile(
            context,
            icon: Icons.account_circle_outlined,
            title: 'Your Photo',
            path: settings.userPhotoPath,
            onPick: () => ref.read(settingsProvider.notifier).pickUserPhoto(),
            onClear: () =>
                ref.read(settingsProvider.notifier).clearUserPhoto(),
          ),
          _photoTile(
            context,
            icon: Icons.favorite_border,
            title: "Partner's Photo",
            path: settings.partnerPhotoPath,
            onPick: () =>
                ref.read(settingsProvider.notifier).pickPartnerPhoto(),
            onClear: () =>
                ref.read(settingsProvider.notifier).clearPartnerPhoto(),
          ),
          const SizedBox(height: 16),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
