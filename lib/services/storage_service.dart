import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/relationship_settings.dart';

/// Handles reading and writing [RelationshipSettings] to local device
/// storage via SharedPreferences.
class StorageService {
  static const _settingsKey = 'relationship_settings';

  Future<RelationshipSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) return RelationshipSettings.defaults();

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return RelationshipSettings.fromJson(json);
    } catch (_) {
      // Corrupted or incompatible data: fall back to defaults rather than
      // crashing the app on launch.
      return RelationshipSettings.defaults();
    }
  }

  Future<void> saveSettings(RelationshipSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
