String roudedDateTimeToString() {
  DateTime now = DateTime.now().toUtc();
  DateTime roundedTime =
      DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);
  String roundedTimeString = roundedTime.toIso8601String();
  return roundedTimeString;
}
