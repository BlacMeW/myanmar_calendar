/// Hindu Calendar Calculation Engine
///
/// This file contains the core calculation engine for Hindu calendar
/// conversions and astronomical calculations.
library;

import 'math_functions.dart';
import 'name_functions.dart';

/// Extension to add frac method to double
extension DoubleExtension on double {
  double get frac => this - truncate();
}

/// Main calculation engine for Hindu calendar
class HinduCalculationEngine {
  // Constants for calculations
  static const double earthRadius = 6371.0; // km
  static const double astronomicalUnit = 149597870.7; // km
  static const double tropicalYear = 365.24219; // days
  static const double synodicMonth = 29.530588; // days

  /// Convert Gregorian date to Julian Day Number
  static double gregorianToJulian(int year, int month, int day) {
    int a = (14 - month) ~/ 12;
    int y = year - a;
    int m = month + 12 * a - 3;

    return day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 + 1721119;
  }

  /// Calculate sun's longitude for a given Julian day
  static double getSunLongitude(double julianDay) {
    double t = (julianDay - 2451545.0) / 36525.0;
    double l0 = 280.46646 + t * (36000.76983 + t * 0.0003032);
    double m = 357.52911 + t * (35999.05029 - t * 0.0001537);
    double c =
        sind(m) * (1.914602 - t * (0.004817 + 0.000014 * t)) +
        sind(2 * m) * (0.019993 - 0.000101 * t) +
        sind(3 * m) * 0.000289;

    return normalizeAngle(l0 + c);
  }

  /// Calculate moon's longitude for a given Julian day
  static double getMoonLongitude(double julianDay) {
    double t = (julianDay - 2451545.0) / 36525.0;
    double l =
        218.3164477 +
        t * (481267.88123421 - t * (0.0015786 + t * (1.0 / 538841.0 - t / 65194000.0)));
    double m =
        134.9633964 + t * (477198.8675055 + t * (0.0087472 + t * (1.0 / 69699.0) - t / 14712000.0));
    double mp = 357.5291092 + t * (35999.0502909 - t * (0.0001536 + t / 24490000.0));
    double d =
        297.8501921 + t * (445267.1114034 - t * (0.0018819 - t / 545868.0 + t / 113065000.0));
    double f =
        93.2720950 + t * (483202.0175233 - t * (0.0036539 - t / 3526000.0 + t / 863310000.0));

    // Main periodic terms
    double longitude =
        l +
        6.288774 * sind(m) +
        1.274027 * sind(2 * d - m) +
        0.658314 * sind(2 * d) +
        0.213618 * sind(2 * m) -
        0.185116 * sind(mp) -
        0.114332 * sind(2 * f);

    return normalizeAngle(longitude);
  }

  /// Calculate tithi (lunar day) from sun and moon longitudes
  static double getTithi(double sunLong, double moonLong) {
    double diff = normalizeAngle(moonLong - sunLong);
    return (diff / 12.0) + 1.0;
  }

  /// Calculate nakshatra from moon's longitude
  static int getNakshatra(double moonLong) {
    return ((moonLong / 13.333333).floor() + 1).clamp(1, 27);
  }

  /// Calculate yoga from sun and moon longitudes
  static int getYoga(double sunLong, double moonLong) {
    double sum = normalizeAngle(sunLong + moonLong);
    return ((sum / 13.333333).floor() + 1).clamp(1, 27);
  }

  /// Calculate karana from tithi
  static int getKarana(double tithi) {
    int tithiNum = tithi.floor();
    if (tithiNum == 30) return 11; // Naga karana
    if (tithiNum == 1) return 11; // Kimstughna karana

    int karanaIndex = ((tithiNum - 1) * 2 + (tithi.frac >= 0.5 ? 1 : 0)) % 7;
    return karanaIndex + 1;
  }

  /// Get weekday from Julian day
  static int getWeekday(double julianDay) {
    return ((julianDay + 1.5).floor() % 7);
  }

  /// Calculate approximate Hindu month from sun's longitude
  static int getHinduMonth(double sunLong) {
    return ((sunLong / 30.0).floor() + 1).clamp(1, 12);
  }

  /// Calculate current Muhurta (48-minute periods) for a given time
  static Map<String, dynamic> getMuhurta(DateTime dateTime) {
    // Convert to local time for accurate Muhurta calculation
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Calculate total minutes from midnight
    int totalMinutes = hour * 60 + minute;

    // Determine if it's day or night
    // Simplified: 6 AM to 6 PM is day (12 hours = 15 muhurtas)
    // 6 PM to 6 AM is night (12 hours = 15 muhurtas)
    bool isDay = hour >= 6 && hour < 18;

    if (isDay) {
      // Day muhurtas (6 AM to 6 PM)
      int dayMuhurtaIndex = ((totalMinutes - 360) / 48).floor().clamp(
        0,
        14,
      ); // 360 = 6 AM in minutes
      return {
        'muhurtaIndex': dayMuhurtaIndex + 1,
        'muhurtaName': getDayMuhurtaName(dayMuhurtaIndex + 1),
        'isDay': true,
        'period': 'Day',
      };
    } else {
      // Night muhurtas (6 PM to 6 AM)
      int nightMinutes = hour < 6
          ? totalMinutes + 360
          : totalMinutes - 1080; // Adjust for night calculation
      int nightMuhurtaIndex = (nightMinutes / 48).floor().clamp(0, 14);
      return {
        'muhurtaIndex': nightMuhurtaIndex + 1,
        'muhurtaName': getNightMuhurtaName(nightMuhurtaIndex + 1),
        'isDay': false,
        'period': 'Night',
      };
    }
  }

  /// Calculate Hindu calendar data for a given Gregorian date
  static Map<String, dynamic> calculateHinduDate(
    int year,
    int month,
    int day, {
    double latitude = 0.0,
    double longitude = 0.0,
  }) {
    double julianDay = gregorianToJulian(year, month, day);

    // Calculate astronomical positions
    double sunLong = getSunLongitude(julianDay);
    double moonLong = getMoonLongitude(julianDay);

    // Calculate Hindu calendar elements
    double tithiValue = getTithi(sunLong, moonLong);
    int tithiNum = tithiValue.floor().clamp(1, 30);
    int nakshatra = getNakshatra(moonLong);
    int yoga = getYoga(sunLong, moonLong);
    int karana = getKarana(tithiValue);
    int weekday = getWeekday(julianDay);
    int hinduMonth = getHinduMonth(sunLong);

    // Determine paksha (lunar fortnight)
    bool isShukla = tithiNum <= 15;
    int pakshaDay = isShukla ? tithiNum : tithiNum - 15;

    // Approximate Hindu year calculation
    int hinduYear = year + 57; // Rough approximation

    // Calculate current Muhurta
    DateTime currentTime = DateTime(year, month, day, DateTime.now().hour, DateTime.now().minute);
    Map<String, dynamic> muhurtaInfo = getMuhurta(currentTime);

    return {
      'gregorianYear': year,
      'gregorianMonth': month,
      'gregorianDay': day,
      'julianDay': julianDay,
      'hinduYear': hinduYear,
      'hinduMonth': hinduMonth,
      'hinduDay': pakshaDay,
      'monthName': getMonthName(hinduMonth),
      'tithi': pakshaDay,
      'tithiName': getTithiName(pakshaDay),
      'paksha': getPakshaName(isShukla),
      'nakshatra': nakshatra,
      'nakshatraName': getNakshatraName(nakshatra),
      'yoga': yoga,
      'yogaName': getYogaName(yoga),
      'karana': karana,
      'karanaName': getKaranaName(karana),
      'weekday': weekday,
      'weekdayName': getWeekdayName(weekday),
      'ritu': getRituName(hinduMonth),
      'sunLongitude': sunLong,
      'moonLongitude': moonLong,
      'tithiValue': tithiValue,
      'muhurtaIndex': muhurtaInfo['muhurtaIndex'],
      'muhurtaName': muhurtaInfo['muhurtaName'],
      'muhurtaIsDay': muhurtaInfo['isDay'],
      'muhurtaPeriod': muhurtaInfo['period'],
    };
  }

  /// Convert Hindu date to approximate Gregorian date
  static DateTime hinduToGregorian(int hinduYear, int hinduMonth, int hinduDay, bool isShukla) {
    // This is a simplified approximation
    int gregorianYear = hinduYear - 57;

    // Approximate month conversion
    int gregorianMonth = hinduMonth;
    if (gregorianMonth > 12) gregorianMonth = 12;
    if (gregorianMonth < 1) gregorianMonth = 1;

    // Approximate day calculation
    int gregorianDay = hinduDay;
    if (!isShukla) {
      gregorianDay += 15; // Add 15 days for Krishna paksha
    }

    // Clamp day to valid range
    if (gregorianDay > 28) {
      gregorianDay = 28; // Safe value for all months
    }
    if (gregorianDay < 1) {
      gregorianDay = 1;
    }

    try {
      return DateTime(gregorianYear, gregorianMonth, gregorianDay);
    } catch (e) {
      // Return current date if calculation fails
      return DateTime.now();
    }
  }
}
