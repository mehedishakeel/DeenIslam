/// Tabular (arithmetical) Islamic calendar.
///
/// This is a calculation, not a moon sighting: the real start of a month can
/// differ by one day (or two) between countries and communities, so callers
/// pass a user-controlled [adjustDays]. It matches the civil Hijri date for
/// e.g. 1 Shawwal 1447 = 2026-03-20 and 1 Muharram 1448 = 2026-06-17.
class HijriDate {
  final int year;
  final int month; // 1..12
  final int day; // 1..30

  const HijriDate(this.year, this.month, this.day);

  static const List<String> monthNamesBn = [
    'মুহাররম', 'সফর', 'রবিউল আউয়াল', 'রবিউস সানী', 'জমাদিউল আউয়াল', 'জমাদিউস সানী',
    'রজব', 'শাবান', 'রমজান', 'শাওয়াল', 'জিলকদ', 'জিলহজ্জ',
  ];

  String get monthNameBn => monthNamesBn[month - 1];

  static int _julianDayNumber(int y, int m, int d) {
    final a = (14 - m) ~/ 12;
    final y2 = y + 4800 - a;
    final m2 = m + 12 * a - 3;
    return d +
        (153 * m2 + 2) ~/ 5 +
        365 * y2 +
        y2 ~/ 4 -
        y2 ~/ 100 +
        y2 ~/ 400 -
        32045;
  }

  /// Hijri date of the Gregorian calendar day [date] (time of day ignored),
  /// shifted by [adjustDays] (e.g. +1 / -1 to follow local moon sighting).
  factory HijriDate.fromGregorian(DateTime date, {int adjustDays = 0}) {
    final shifted = DateTime.utc(date.year, date.month, date.day)
        .add(Duration(days: adjustDays));
    final jd = _julianDayNumber(shifted.year, shifted.month, shifted.day);
    var l = jd - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final m = (24 * l) ~/ 709;
    final d = l - (709 * m) ~/ 24;
    final y = 30 * n + j - 30;
    return HijriDate(y, m, d);
  }

  @override
  bool operator ==(Object other) =>
      other is HijriDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$year-$month-$day';
}
