import 'package:flutter/material.dart';

import 'display_format.dart';

/// Sentinel used by [RelationshipSettings.copyWith] so that nullable fields
/// (the optional photo paths) can be explicitly cleared to null, which is
/// indistinguishable from "not passed" under the usual `?? this.x` pattern.
const _unset = Object();

/// Persisted settings for the relationship counter app.
class RelationshipSettings {
  const RelationshipSettings({
    required this.startDate,
    this.userName = '',
    this.partnerName = '',
    this.reminderEnabled = true,
    this.reminderHour = 21,
    this.reminderMinute = 0,
    this.reminderMessage = "Don't forget to say good night.",
    this.themeMode = ThemeMode.system,
    this.displayFormat = DisplayFormat.days,
    this.backgroundImagePath,
    this.userPhotoPath,
    this.partnerPhotoPath,
  });

  final DateTime startDate;
  final String userName;
  final String partnerName;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final String reminderMessage;
  final ThemeMode themeMode;
  final DisplayFormat displayFormat;
  final String? backgroundImagePath;
  final String? userPhotoPath;
  final String? partnerPhotoPath;

  TimeOfDay get reminderTime =>
      TimeOfDay(hour: reminderHour, minute: reminderMinute);

  static RelationshipSettings defaults() => RelationshipSettings(
    startDate: DateTime.now(),
  );

  RelationshipSettings copyWith({
    DateTime? startDate,
    String? userName,
    String? partnerName,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    String? reminderMessage,
    ThemeMode? themeMode,
    DisplayFormat? displayFormat,
    Object? backgroundImagePath = _unset,
    Object? userPhotoPath = _unset,
    Object? partnerPhotoPath = _unset,
  }) {
    return RelationshipSettings(
      startDate: startDate ?? this.startDate,
      userName: userName ?? this.userName,
      partnerName: partnerName ?? this.partnerName,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      reminderMessage: reminderMessage ?? this.reminderMessage,
      themeMode: themeMode ?? this.themeMode,
      displayFormat: displayFormat ?? this.displayFormat,
      backgroundImagePath: identical(backgroundImagePath, _unset)
          ? this.backgroundImagePath
          : backgroundImagePath as String?,
      userPhotoPath: identical(userPhotoPath, _unset)
          ? this.userPhotoPath
          : userPhotoPath as String?,
      partnerPhotoPath: identical(partnerPhotoPath, _unset)
          ? this.partnerPhotoPath
          : partnerPhotoPath as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'userName': userName,
    'partnerName': partnerName,
    'reminderEnabled': reminderEnabled,
    'reminderHour': reminderHour,
    'reminderMinute': reminderMinute,
    'reminderMessage': reminderMessage,
    'themeMode': themeMode.name,
    'displayFormat': displayFormat.name,
    'backgroundImagePath': backgroundImagePath,
    'userPhotoPath': userPhotoPath,
    'partnerPhotoPath': partnerPhotoPath,
  };

  factory RelationshipSettings.fromJson(Map<String, dynamic> json) {
    final defaults = RelationshipSettings.defaults();
    return RelationshipSettings(
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ??
          defaults.startDate,
      userName: json['userName'] as String? ?? defaults.userName,
      partnerName: json['partnerName'] as String? ?? defaults.partnerName,
      reminderEnabled:
          json['reminderEnabled'] as bool? ?? defaults.reminderEnabled,
      reminderHour: json['reminderHour'] as int? ?? defaults.reminderHour,
      reminderMinute:
          json['reminderMinute'] as int? ?? defaults.reminderMinute,
      reminderMessage:
          json['reminderMessage'] as String? ?? defaults.reminderMessage,
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == json['themeMode'],
        orElse: () => defaults.themeMode,
      ),
      displayFormat: DisplayFormat.values.firstWhere(
        (f) => f.name == json['displayFormat'],
        orElse: () => defaults.displayFormat,
      ),
      backgroundImagePath: json['backgroundImagePath'] as String?,
      userPhotoPath: json['userPhotoPath'] as String?,
      partnerPhotoPath: json['partnerPhotoPath'] as String?,
    );
  }
}
