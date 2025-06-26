import 'myanmar_calendar_core.dart';
import 'myanmar_date.dart';

/// High-level converter class for Myanmar calendar conversions
class MyanmarCalendarConverter {
  /// Convert Gregorian date to Myanmar date
  static MyanmarDate gregorianToMyanmar(DateTime gregorianDate) {
    double jdn = MyanmarCalendarCore.gregorianToJdn(
      gregorianDate.year,
      gregorianDate.month,
      gregorianDate.day,
    );
    return MyanmarCalendarCore.jdnToMyanmar(jdn);
  }

  /// Convert Myanmar date to Gregorian date
  static DateTime myanmarToGregorian(MyanmarDate myanmarDate) {
    double jdn = MyanmarCalendarCore.myanmarToJdn(myanmarDate);
    List<int> gregorian = MyanmarCalendarCore.jdnToGregorian(jdn);
    return DateTime(gregorian[0], gregorian[1], gregorian[2]);
  }

  /// Convert Gregorian date from year, month, day integers
  static MyanmarDate gregorianToMyanmarFromInts(int year, int month, int day) {
    double jdn = MyanmarCalendarCore.gregorianToJdn(year, month, day);
    return MyanmarCalendarCore.jdnToMyanmar(jdn);
  }

  /// Convert Myanmar date to Gregorian date as formatted string
  static String myanmarToGregorianString(MyanmarDate myanmarDate, {String format = 'yyyy-MM-dd'}) {
    DateTime gregorian = myanmarToGregorian(myanmarDate);

    switch (format) {
      case 'yyyy-MM-dd':
        return '${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}';
      case 'dd/MM/yyyy':
        return '${gregorian.day.toString().padLeft(2, '0')}/${gregorian.month.toString().padLeft(2, '0')}/${gregorian.year}';
      case 'MM/dd/yyyy':
        return '${gregorian.month.toString().padLeft(2, '0')}/${gregorian.day.toString().padLeft(2, '0')}/${gregorian.year}';
      case 'full':
        return _formatGregorianDateFull(gregorian);
      default:
        return '${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}';
    }
  }

  /// Format Gregorian date with full month name
  static String _formatGregorianDateFull(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  /// Get today's date in Myanmar calendar
  static MyanmarDate getMyanmarToday() {
    return MyanmarCalendarCore.today();
  }

  /// Get the day of week for a Myanmar date
  static int getMyanmarDayOfWeek(MyanmarDate myanmarDate) {
    double jdn = MyanmarCalendarCore.myanmarToJdn(myanmarDate);
    return MyanmarCalendarCore.getDayOfWeek(jdn);
  }

  /// Get the day name in Myanmar for a Myanmar date
  static String getMyanmarDayName(MyanmarDate myanmarDate) {
    int dayOfWeek = getMyanmarDayOfWeek(myanmarDate);
    return MyanmarDate.dayNames[dayOfWeek];
  }

  /// Check if a Myanmar year has an intercalary month (watat)
  static bool isWatatYear(int myanmarYear) {
    return MyanmarCalendarCore.isWatatYear(myanmarYear);
  }

  /// Get the number of days in a specific Myanmar month
  static int getDaysInMyanmarMonth(int myanmarYear, int month) {
    return MyanmarCalendarCore.getDaysInMonth(myanmarYear, month);
  }

  /// Get all days in a Myanmar month
  static List<MyanmarDate> getMyanmarMonth(int myanmarYear, int month) {
    int daysInMonth = getDaysInMyanmarMonth(myanmarYear, month);
    List<MyanmarDate> days = [];

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(
        MyanmarDate(
          year: myanmarYear,
          month: month,
          day: day,
          isIntercalaryMonth: isWatatYear(myanmarYear) && month == 0,
        ),
      );
    }

    return days;
  }

  /// Get Myanmar calendar for a specific month with Gregorian equivalents
  static Map<String, dynamic> getMyanmarCalendarMonth(int myanmarYear, int month) {
    List<MyanmarDate> myanmarDays = getMyanmarMonth(myanmarYear, month);
    List<Map<String, dynamic>> calendarDays = [];

    for (MyanmarDate myanmarDay in myanmarDays) {
      DateTime gregorian = myanmarToGregorian(myanmarDay);
      int dayOfWeek = getMyanmarDayOfWeek(myanmarDay);

      calendarDays.add({
        'myanmarDate': myanmarDay,
        'gregorianDate': gregorian,
        'dayOfWeek': dayOfWeek,
        'dayName': MyanmarDate.dayNames[dayOfWeek],
        'isWaxing': myanmarDay.day <= 15,
        'isFullMoon': myanmarDay.day == 15,
        'isWaning': myanmarDay.day > 15,
      });
    }

    return {
      'year': myanmarYear,
      'month': month,
      'monthName': month < MyanmarDate.monthNames.length
          ? MyanmarDate.monthNames[month]
          : 'Unknown',
      'isWatatYear': isWatatYear(myanmarYear),
      'isIntercalaryMonth': isWatatYear(myanmarYear) && month == 0,
      'days': calendarDays,
    };
  }

  /// Convert a range of Gregorian dates to Myanmar dates
  static List<Map<String, dynamic>> convertDateRange(DateTime startDate, DateTime endDate) {
    List<Map<String, dynamic>> conversions = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      MyanmarDate myanmarDate = gregorianToMyanmar(currentDate);

      conversions.add({
        'gregorian': currentDate,
        'myanmar': myanmarDate,
        'dayOfWeek': getMyanmarDayOfWeek(myanmarDate),
        'dayName': getMyanmarDayName(myanmarDate),
      });

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return conversions;
  }

  /// Find Myanmar holidays and special days
  static List<Map<String, dynamic>> getMyanmarHolidays(int myanmarYear) {
    List<Map<String, dynamic>> holidays = [];

    // Full moon days are generally considered special
    for (int month = 0; month < 12; month++) {
      // Skip if this would be an invalid month in a non-watat year
      if (!isWatatYear(myanmarYear) && month == 0) continue;

      MyanmarDate fullMoonDay = MyanmarDate(year: myanmarYear, month: month, day: 15);

      holidays.add({
        'name': '${MyanmarDate.monthNames[month]} လပြည့်',
        'date': fullMoonDay,
        'type': 'full_moon',
        'description': 'Full moon day of ${MyanmarDate.monthNames[month]}',
      });
    }

    // Thingyan (Myanmar New Year) - usually in Tagu month
    if (!isWatatYear(myanmarYear) || isWatatYear(myanmarYear)) {
      int taguMonth = isWatatYear(myanmarYear) ? 1 : 0; // Adjust for watat year

      holidays.add({
        'name': 'သင်္ကြန်',
        'date': MyanmarDate(year: myanmarYear, month: taguMonth, day: 1),
        'type': 'new_year',
        'description': 'Myanmar New Year (Thingyan)',
      });
    }

    return holidays;
  }

  /// Convert Myanmar date to Gregorian date using integer inputs
  /// Returns formatted date string "YYYY-MM-DD"
  static String myanmarIntsToGregorian(int myYear, int myMonth, int myDay) {
    MyanmarDate myanmarDate = MyanmarDate(year: myYear, month: myMonth, day: myDay);
    return myanmarToGregorianString(myanmarDate, format: 'yyyy-MM-dd');
  }

  /// Convert Myanmar date to Gregorian with readable month names using integer inputs
  /// Returns formatted date string "Day Month Year"
  static String myanmarIntsToGregorianFull(int myYear, int myMonth, int myDay) {
    MyanmarDate myanmarDate = MyanmarDate(year: myYear, month: myMonth, day: myDay);
    return myanmarToGregorianString(myanmarDate, format: 'full');
  }
}
