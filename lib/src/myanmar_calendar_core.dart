import 'myanmar_date.dart';

/// Core Myanmar calendar conversion and calculation functions
class MyanmarCalendarCore {
  /// Solar Year (SY): tropical year (365.2587565)
  static const double solarYear = 1577917828.0 / 4320000.0;

  /// Lunar Month (LM): synodic month (29.53058794)
  static const double lunarMonth = 1577917828.0 / 53433336.0;

  /// Base Julian Day Number for Myanmar Era start
  static const double baseJdn = 1954168.050623;

  /// Number of months in a regular year
  static const int monthsPerYear = 12;

  /// Myanmar Era start year
  static const int myanmarEraStart = 638;

  /// Convert Gregorian date to Julian Day Number
  static double gregorianToJdn(int year, int month, int day) {
    if (month < 3) {
      year = year - 1;
      month = month + 12;
    }
    double julianDay = (365.25 * year).toInt() + (30.59 * (month - 2)).toInt() + day + 1721086.5;
    if (year < 0) {
      julianDay = julianDay - 1;
      if ((year % 4) == 0 && 3 <= month) {
        julianDay = julianDay + 1;
      }
    }
    if (2299160 < julianDay) {
      julianDay = julianDay + (year / 400).toInt() - (year / 100).toInt() + 2;
    }
    return julianDay;
  }

  /// Convert Julian Day Number to Gregorian date
  static List<int> jdnToGregorian(double jd) {
    int J = jd.floor() + 32044;
    int g = J ~/ 146097;
    int dg = J % 146097;
    int c = ((dg ~/ 36524) + 1) * 3 ~/ 4;
    int dc = dg - c * 36524;
    int b = dc ~/ 1461;
    int db = dc % 1461;
    int a = ((db ~/ 365) + 1) * 3 ~/ 4;
    int da = db - a * 365;
    int y = g * 400 + c * 100 + b * 4 + a;
    int m = (da * 5 + 308) ~/ 153 - 2;
    int d = da - ((m + 4) * 153 ~/ 5) + 122;
    int year = y - 4800 + ((m + 2) ~/ 12);
    int month = (m + 2) % 12 + 1;
    int day = d + 1;
    return [year, month, day];
  }

  /// Calculate Myanmar calendar system parameters for a given year
  static Map<String, dynamic> calculateMyanmarYear(int myanmarYear) {
    var result = _calMy(myanmarYear);
    return {
      'yearType': result[0],
      'hasWatat': result[0] > 0,
      'firstNewMoon': result[2],
      'firstDayOfYear': result[1],
      'yearDays': result[0] > 0 ? 384 : 354,
    };
  }

  /// Convert Julian Day Number to Myanmar date
  static MyanmarDate jdnToMyanmar(double jdn) {
    var result = _j2m(jdn);
    return MyanmarDate(
      year: result[1],
      month: result[2],
      day: result[3],
      dayType: result[0],
      isIntercalaryMonth: result[0] > 0 && result[2] >= 13,
    );
  }

  /// Convert Myanmar date to Julian Day Number
  static double myanmarToJdn(MyanmarDate myanmarDate) {
    return _myanmarToJdn(myanmarDate.year, myanmarDate.month, myanmarDate.day);
  }

  /// Internal Myanmar calendar calculation logic (j2m)
  /// Returns: [myt, my, mm, md]
  static List<int> _j2m(double jd) {
    int jdn = jd.round();
    double SY = 1577917828.0 / 4320000.0;
    double MO = 1954168.050623;
    int my = ((jdn - 0.5 - MO) / SY).floor();
    var mytTg1FmWerr = _calMy(my);
    int myt = mytTg1FmWerr[0];
    int tg1 = mytTg1FmWerr[1];
    // fm and werr are not used in this calculation but kept for completeness
    // int fm = mytTg1FmWerr[2];
    // int werr = mytTg1FmWerr[3];

    int dd = jdn - tg1 + 1;
    int b = (myt / 2).floor();
    int c = (1 / (myt + 1)).floor();
    int myl = 354 + (1 - c) * 30 + b;
    int mmt = ((dd - 1) / myl).floor();
    dd -= mmt * myl;
    int a = ((dd + 423) / 512).floor();
    int mm = ((dd - b * a + c * a * 30 + 29.26) / 29.544).floor();
    int e = ((mm + 12) / 16).floor();
    int f = ((mm + 11) / 16).floor();
    int md = dd - (29.544 * mm - 29.26).floor() - b * e + c * f * 30;
    mm += f * 3 - e * 4 + 12 * mmt;
    return [myt, my, mm, md];
  }

  /// Internal: Check Myanmar Year
  /// Returns: [myt, tg1, fm, werr]
  static List<int> _calMy(int my) {
    int yd = 0, nd = 0, y1watat = 0, y1fm = 0, y2watat = 0, y2fm = 0, werr = 0;
    var y2 = _calWatat(my);
    y2watat = y2[0];
    y2fm = y2[1];
    int myt = y2watat;
    do {
      yd++;
      var y1 = _calWatat(my - yd);
      y1watat = y1[0];
      y1fm = y1[1];
    } while (y1watat == 0 && yd < 3);
    int fm;
    if (myt != 0) {
      nd = (y2fm - y1fm) % 354;
      myt = (nd / 31).floor() + 1;
      fm = y2fm;
      if (nd != 30 && nd != 31) werr = 1;
    } else {
      fm = y1fm + 354 * yd;
    }
    int tg1 = y1fm + 354 * yd - 102;
    return [myt, tg1, fm, werr];
  }

  /// Internal: Check watat (intercalary month)
  /// Returns: [watat, fm]
  static List<int> _calWatat(int my) {
    double SY = 1577917828.0 / 4320000.0;
    double LM = 1577917828.0 / 53433336.0;
    double MO = 1954168.050623;
    double EI = 3, WO = -0.5, NM = 8;
    double TA = (SY / 12 - LM) * (12 - NM);
    double ed = (SY * (my + 3739)) % LM;
    if (ed < TA) ed += LM;
    int fm = (SY * my + MO - ed + 4.5 * LM + WO).round();
    double TW = 0;
    int watat = 0;
    if (EI >= 2) {
      TW = LM - (SY / 12 - LM) * NM;
      if (ed >= TW) watat = 1;
    } else {
      watat = (my * 7 + 2) % 19;
      if (watat < 0) watat += 19;
      watat = (watat / 12).floor();
    }
    return [watat, fm];
  }

  /// Internal: Convert Myanmar date to Julian Day Number
  static double _myanmarToJdn(int myYear, int myMonth, int myDay) {
    // SY and MO constants are defined but not used in this specific calculation
    // double SY = 1577917828.0 / 4320000.0;
    // double MO = 1954168.050623;
    var mytTg1FmWerr = _calMy(myYear);
    int myt = mytTg1FmWerr[0];
    int tg1 = mytTg1FmWerr[1];
    int b = (myt / 2).floor();
    int c = (1 / (myt + 1)).floor();
    int mm = myMonth;
    int mmt = 0;
    if (mm >= 13) {
      mmt = 1;
      mm -= 12;
    }
    if (mm == 0) {
      mm = 4;
      mmt = 0;
    }
    int e = ((mm + 12) / 16).floor();
    int f = ((mm + 11) / 16).floor();
    int dd = myDay;
    mm -= f * 3 - e * 4;
    dd += (29.544 * mm - 29.26).floor() + b * e - c * f * 30;
    dd += mmt * (354 + (1 - c) * 30 + b);

    return tg1 + dd - 1;
  }

  /// Get the day of week for a given Julian Day Number
  /// Returns 0 for Sunday, 1 for Monday, ..., 6 for Saturday
  static int getDayOfWeek(double jdn) {
    return (jdn.floor() + 1) % 7;
  }

  /// Check if a Myanmar year is a watat (intercalary) year
  static bool isWatatYear(int myanmarYear) {
    var yearInfo = calculateMyanmarYear(myanmarYear);
    return yearInfo['hasWatat'];
  }

  /// Get the number of days in a Myanmar month
  static int getDaysInMonth(int myanmarYear, int month) {
    var yearInfo = calculateMyanmarYear(myanmarYear);
    bool hasWatat = yearInfo['hasWatat'];

    List<int> monthDays = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];

    if (hasWatat) {
      monthDays.insert(0, 30);
      monthDays[4] = 29;
    }

    if (month >= 0 && month < monthDays.length) {
      return monthDays[month];
    }
    return 29; // Default
  }

  /// Get today's Myanmar date
  static MyanmarDate today() {
    DateTime now = DateTime.now();
    double jdn = gregorianToJdn(now.year, now.month, now.day);
    return jdnToMyanmar(jdn);
  }
}
