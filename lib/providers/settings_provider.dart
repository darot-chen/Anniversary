import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/relationship_settings.dart';
import 'service_providers.dart';

/// Owns the single [RelationshipSettings] object: persists every change to
/// local storage and keeps scheduled notifications in sync with it.
class SettingsNotifier extends StateNotifier<RelationshipSettings> {
  SettingsNotifier(this._ref, RelationshipSettings initial) : super(initial) {
    _syncReminder();
    _updateHomeWidget();
  }

  final Ref _ref;

  Future<void> _persist() async {
    await _ref.read(storageServiceProvider).saveSettings(state);
    await _updateHomeWidget();
  }

  Future<void> _updateHomeWidget() async {
    await _ref.read(homeWidgetServiceProvider).update(state);
  }

  Future<void> _syncReminder() async {
    final notifications = _ref.read(notificationServiceProvider);
    if (state.reminderEnabled) {
      await notifications.scheduleDailyReminder(
        time: state.reminderTime,
        message: state.reminderMessage,
      );
    } else {
      await notifications.cancelReminder();
    }
  }

  Future<void> updateStartDate(DateTime date) async {
    state = state.copyWith(startDate: date);
    await _persist();
  }

  Future<void> updateUserName(String name) async {
    state = state.copyWith(userName: name);
    await _persist();
  }

  Future<void> updatePartnerName(String name) async {
    state = state.copyWith(partnerName: name);
    await _persist();
  }

  Future<void> setReminderEnabled(bool enabled) async {
    state = state.copyWith(reminderEnabled: enabled);
    await _persist();
    await _syncReminder();
  }

  Future<void> updateReminderTime(TimeOfDay time) async {
    state = state.copyWith(
      reminderHour: time.hour,
      reminderMinute: time.minute,
    );
    await _persist();
    await _syncReminder();
  }

  Future<void> updateReminderMessage(String message) async {
    state = state.copyWith(reminderMessage: message);
    await _persist();
    await _syncReminder();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _persist();
  }

  Future<void> cycleDisplayFormat() async {
    state = state.copyWith(displayFormat: state.displayFormat.next);
    await _persist();
  }

  Future<void> pickBackgroundImage() async {
    final path = await _ref.read(imageServiceProvider).pickAndSaveImage(
      'background',
      isAvatar: false,
    );
    if (path == null) return;
    state = state.copyWith(backgroundImagePath: path);
    await _persist();
  }

  Future<void> clearBackgroundImage() async {
    await _ref.read(imageServiceProvider).deleteImage(
      state.backgroundImagePath,
    );
    state = state.copyWith(backgroundImagePath: null);
    await _persist();
  }

  Future<void> pickUserPhoto() async {
    final path = await _ref.read(imageServiceProvider).pickAndSaveImage(
      'user',
      isAvatar: true,
    );
    if (path == null) return;
    state = state.copyWith(userPhotoPath: path);
    await _persist();
  }

  Future<void> clearUserPhoto() async {
    await _ref.read(imageServiceProvider).deleteImage(state.userPhotoPath);
    state = state.copyWith(userPhotoPath: null);
    await _persist();
  }

  Future<void> pickPartnerPhoto() async {
    final path = await _ref.read(imageServiceProvider).pickAndSaveImage(
      'partner',
      isAvatar: true,
    );
    if (path == null) return;
    state = state.copyWith(partnerPhotoPath: path);
    await _persist();
  }

  Future<void> clearPartnerPhoto() async {
    await _ref.read(imageServiceProvider).deleteImage(
      state.partnerPhotoPath,
    );
    state = state.copyWith(partnerPhotoPath: null);
    await _persist();
  }
}

/// Must be overridden in `main()` with the settings loaded from disk before
/// the app starts, so the UI never needs to render a loading state.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, RelationshipSettings>((ref) {
  throw UnimplementedError('settingsProvider must be overridden in main()');
});
