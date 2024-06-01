import 'package:flutter/material.dart';

enum FilterPreset {
  thisWeek,
  thisMonth,
  lastMonth,
  lastXDays;

  DateTime getStartDate(int firstDayOfWeekIndex, int defaultFilterDays) {
    final now = DateTime.now();
    switch (this) {
      case FilterPreset.thisWeek:
        var durationDiff = now.weekday - firstDayOfWeekIndex;
        if (durationDiff < 0) durationDiff += 7;
        return now.subtract(Duration(days: durationDiff)).copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case FilterPreset.thisMonth:
        return DateTime(now.year, now.month, 1);
      case FilterPreset.lastMonth:
        return DateTime(now.year, now.month - 1, 1);
      case FilterPreset.lastXDays:
        final xDaysAgo =
            DateTime.now().subtract(Duration(days: defaultFilterDays));
        return DateTime(xDaysAgo.year, xDaysAgo.month, xDaysAgo.day);
    }
  }

  DateTime? getEndDate() {
    final now = DateTime.now();
    switch (this) {
      case FilterPreset.thisWeek:
        return null;
      case FilterPreset.thisMonth:
        return DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(seconds: 1));
      case FilterPreset.lastMonth:
        return DateTime(now.year, now.month, 1)
            .subtract(const Duration(seconds: 1));
      case FilterPreset.lastXDays:
        return null;
    }
  }

  String display(BuildContext context, int defaultFilterDays) {
    switch (this) {
      case FilterPreset.thisWeek:
        return "This Week";
      case FilterPreset.thisMonth:
        return "This Month";
      case FilterPreset.lastMonth:
        return "Last Month";
      case FilterPreset.lastXDays:
        return "Last $defaultFilterDays days";
    }
  }
}
