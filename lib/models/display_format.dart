/// How the main day count is rendered on the home screen.
enum DisplayFormat {
  days,
  yearsMonthsDays,
  weeksAndDays;

  /// Tap-to-cycle order: Days -> Years/Months/Days -> Weeks/Days -> Days.
  DisplayFormat get next {
    switch (this) {
      case DisplayFormat.days:
        return DisplayFormat.yearsMonthsDays;
      case DisplayFormat.yearsMonthsDays:
        return DisplayFormat.weeksAndDays;
      case DisplayFormat.weeksAndDays:
        return DisplayFormat.days;
    }
  }
}
