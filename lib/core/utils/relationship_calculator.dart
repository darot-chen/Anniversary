import 'package:intl/intl.dart';

import '../../models/display_format.dart';

/// Size of the day-based anniversary-bar bucket (e.g. 600 -> 700).
const int _dayBucketSize = 100;

class RelationshipStats {
  const RelationshipStats({
    required this.daysTogether,
    required this.years,
    required this.months,
    required this.remainderDays,
    required this.weeks,
    required this.weekRemainderDays,
  });

  /// Total whole days since the start date.
  final int daysTogether;

  /// Full years elapsed (calendar-aware).
  final int years;

  /// Full months elapsed beyond [years] (calendar-aware).
  final int months;

  /// Days elapsed beyond [years] and [months].
  final int remainderDays;

  /// Full weeks elapsed (calendar-agnostic, [daysTogether] ~/ 7).
  final int weeks;

  /// Days elapsed beyond [weeks].
  final int weekRemainderDays;
}

/// Progress of the current relationship "bucket" for the anniversary bar:
/// a day-based hundred bucket (e.g. 600 -> 700) normally, or a year-based
/// bucket (e.g. 2Y -> 3Y) when displaying in [DisplayFormat.yearsMonthsDays].
class AnniversaryBarStats {
  const AnniversaryBarStats({
    required this.startLabel,
    required this.endLabel,
    required this.progress,
    required this.remainingDays,
  });

  final String startLabel;
  final String endLabel;

  /// 0.0 (just entered the bucket) to 1.0 (about to reach [endLabel]).
  final double progress;

  final int remainingDays;
}

class RelationshipCalculator {
  const RelationshipCalculator._();

  /// Truncates a [DateTime] to just its calendar date (no time component),
  /// so day counts are stable regardless of time-of-day or timezone drift.
  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static int daysTogether(DateTime startDate, {DateTime? asOf}) {
    final start = _dateOnly(startDate);
    final now = _dateOnly(asOf ?? DateTime.now());
    return now.difference(start).inDays;
  }

  static RelationshipStats calculate(DateTime startDate, {DateTime? asOf}) {
    final now = _dateOnly(asOf ?? DateTime.now());
    final start = _dateOnly(startDate);
    final totalDays = now.difference(start).inDays;

    // Calendar-aware years/months breakdown.
    var years = now.year - start.year;
    var months = now.month - start.month;
    var days = now.day - start.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (totalDays < 0) {
      years = 0;
      months = 0;
      days = 0;
    }

    final clampedTotalDays = totalDays < 0 ? 0 : totalDays;

    return RelationshipStats(
      daysTogether: totalDays,
      years: years,
      months: months,
      remainderDays: days,
      weeks: clampedTotalDays ~/ 7,
      weekRemainderDays: clampedTotalDays % 7,
    );
  }

  /// Renders [stats] as the large home-screen counter text for [format].
  static String formatCount(RelationshipStats stats, DisplayFormat format) {
    switch (format) {
      case DisplayFormat.days:
        final formatted = NumberFormat.decimalPattern().format(
          stats.daysTogether,
        );
        return '$formatted Days';
      case DisplayFormat.yearsMonthsDays:
        return '${stats.years}Y ${stats.months}M ${stats.remainderDays}D';
      case DisplayFormat.weeksAndDays:
        return '${stats.weeks}W ${stats.weekRemainderDays}D';
    }
  }

  /// Computes the anniversary-bar bucket for [format]: a day-based hundred
  /// bucket normally, or a year-based bucket in years/months/days mode.
  static AnniversaryBarStats anniversaryBar(
    DateTime startDate,
    DisplayFormat format, {
    DateTime? asOf,
  }) {
    final now = _dateOnly(asOf ?? DateTime.now());
    final start = _dateOnly(startDate);

    if (format == DisplayFormat.yearsMonthsDays) {
      var years = now.year - start.year;
      var anchor = DateTime(start.year + years, start.month, start.day);
      if (anchor.isAfter(now)) {
        years -= 1;
        anchor = DateTime(start.year + years, start.month, start.day);
      }
      if (years < 0) years = 0;
      anchor = DateTime(start.year + years, start.month, start.day);
      final nextAnchor = DateTime(start.year + years + 1, start.month, start.day);
      final bucketDays = nextAnchor.difference(anchor).inDays;
      final elapsed = now.difference(anchor).inDays;

      return AnniversaryBarStats(
        startLabel: '${years}Y',
        endLabel: '${years + 1}Y',
        progress: bucketDays == 0
            ? 0.0
            : (elapsed / bucketDays).clamp(0.0, 1.0),
        remainingDays: nextAnchor.difference(now).inDays,
      );
    }

    final totalDays = now.difference(start).inDays.clamp(0, 1 << 30);
    final bucketStart = (totalDays ~/ _dayBucketSize) * _dayBucketSize;
    final bucketEnd = bucketStart + _dayBucketSize;

    return AnniversaryBarStats(
      startLabel: '$bucketStart',
      endLabel: '$bucketEnd',
      progress: (totalDays - bucketStart) / _dayBucketSize,
      remainingDays: bucketEnd - totalDays,
    );
  }
}
