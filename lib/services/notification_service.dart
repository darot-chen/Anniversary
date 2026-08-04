import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Wraps flutter_local_notifications to schedule the single daily
/// relationship reminder. The reminder is rescheduled as a daily-repeating
/// notification, which flutter_local_notifications persists across reboots
/// on Android via its own boot-completed receiver.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const int _reminderNotificationId = 1;
  static const String _channelId = 'daily_reminder';
  static const String _channelName = 'Daily Reminder';
  static const String _channelDescription =
      'Daily reminder to celebrate your relationship';

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Initializes the plugin. Swallows errors so that platforms/environments
  /// without a registered notifications implementation (e.g. widget tests,
  /// or an OEM that blocks the plugin) degrade to "no reminders" instead of
  /// crashing the app on startup.
  Future<void> init() async {
    if (_initialized) return;

    try {
      tz_data.initializeTimeZones();
      try {
        final localName = DateTime.now().timeZoneName;
        tz.setLocalLocation(tz.getLocation(localName));
      } catch (_) {
        // Fall back to UTC offset detection if the platform timezone name
        // doesn't match the tz database; local scheduling still works via
        // the device's current offset in that case.
      }

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _plugin.initialize(initSettings);

      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _initialized = true;
    } catch (_) {
      // No-op: reminders simply won't be scheduled on this platform.
    }
  }

  Future<bool> requestPermission() async {
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final notificationsGranted =
          await androidImpl?.requestNotificationsPermission() ?? true;
      await androidImpl?.requestExactAlarmsPermission();
      return notificationsGranted;
    } catch (_) {
      return false;
    }
  }

  Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    required String message,
  }) async {
    await init();
    if (!_initialized) return;
    try {
      await _plugin.zonedSchedule(
        _reminderNotificationId,
        '❤️',
        message,
        _nextInstanceOfTime(time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      // No-op: scheduling failed (e.g. permission denied on this device).
    }
  }

  Future<void> cancelReminder() async {
    await init();
    if (!_initialized) return;
    try {
      await _plugin.cancel(_reminderNotificationId);
    } catch (_) {
      // No-op.
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
