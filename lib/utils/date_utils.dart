DateTime firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

DateTime firstSaturdayOfMonth(DateTime date) {
  DateTime firstDay = DateTime(date.year, date.month, 1);

  int weekday = firstDay.weekday; // Mon=1 ... Sun=7
  int daysToAdd = (6 - weekday) % 7;

  return firstDay.add(Duration(days: daysToAdd));
}
