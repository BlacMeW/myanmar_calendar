/// Panchanga Date class for Hindu calendar
///
/// This class represents a complete Hindu calendar date with all
/// panchanga elements (five limbs of time).
library;

/// Represents a complete Hindu calendar date
class PancangaDate {
  /// Gregorian year
  final int gregorianYear;

  /// Gregorian month
  final int gregorianMonth;

  /// Gregorian day
  final int gregorianDay;

  /// Hindu lunar month name
  final String lunarMonth;

  /// Hindu lunar month number (1-12)
  final int lunarMonthNumber;

  /// Paksha (bright/dark fortnight)
  final String paksha;

  /// Tithi (lunar day) number (1-30/15)
  final int tithiNumber;

  /// Tithi name
  final String tithiName;

  /// Nakshatra (lunar mansion) number (1-27)
  final int nakshatraNumber;

  /// Nakshatra name
  final String nakshatraName;

  /// Yoga number (1-27)
  final int yogaNumber;

  /// Yoga name
  final String yogaName;

  /// Karana number (1-11)
  final int karanaNumber;

  /// Karana name
  final String karanaName;

  /// Vara (weekday) number (0-6, Sunday=0)
  final int varaNumber;

  /// Vara name
  final String varaName;

  /// Ritu (season) name
  final String rituName;

  /// Masa (solar month) name
  final String masaName;

  /// Hindu year
  final int hinduYear;

  /// Julian day number
  final double julianDay;

  /// Sun's longitude in degrees
  final double sunLongitude;

  /// Moon's longitude in degrees
  final double moonLongitude;

  /// Muhurta index (1-15)
  final int muhurtaIndex;

  /// Muhurta name
  final String muhurtaName;

  /// Whether the muhurta is during day time
  final bool muhurtaIsDay;

  /// Muhurta period (Day/Night)
  final String muhurtaPeriod;

  const PancangaDate({
    required this.gregorianYear,
    required this.gregorianMonth,
    required this.gregorianDay,
    required this.lunarMonth,
    required this.lunarMonthNumber,
    required this.paksha,
    required this.tithiNumber,
    required this.tithiName,
    required this.nakshatraNumber,
    required this.nakshatraName,
    required this.yogaNumber,
    required this.yogaName,
    required this.karanaNumber,
    required this.karanaName,
    required this.varaNumber,
    required this.varaName,
    required this.rituName,
    required this.masaName,
    required this.hinduYear,
    required this.julianDay,
    required this.sunLongitude,
    required this.moonLongitude,
    required this.muhurtaIndex,
    required this.muhurtaName,
    required this.muhurtaIsDay,
    required this.muhurtaPeriod,
  });

  /// Create a PancangaDate from calculation results
  factory PancangaDate.fromCalculation(Map<String, dynamic> calculation) {
    return PancangaDate(
      gregorianYear: calculation['gregorianYear'] ?? 0,
      gregorianMonth: calculation['gregorianMonth'] ?? 0,
      gregorianDay: calculation['gregorianDay'] ?? 0,
      lunarMonth: calculation['monthName'] ?? '',
      lunarMonthNumber: calculation['hinduMonth'] ?? 1,
      paksha: calculation['paksha'] ?? '',
      tithiNumber: calculation['tithi'] ?? 1,
      tithiName: calculation['tithiName'] ?? '',
      nakshatraNumber: calculation['nakshatra'] ?? 1,
      nakshatraName: calculation['nakshatraName'] ?? '',
      yogaNumber: calculation['yoga'] ?? 1,
      yogaName: calculation['yogaName'] ?? '',
      karanaNumber: calculation['karana'] ?? 1,
      karanaName: calculation['karanaName'] ?? '',
      varaNumber: calculation['weekday'] ?? 0,
      varaName: calculation['weekdayName'] ?? '',
      rituName: calculation['ritu'] ?? '',
      masaName: calculation['monthName'] ?? '',
      hinduYear: calculation['hinduYear'] ?? 0,
      julianDay: calculation['julianDay'] ?? 0.0,
      sunLongitude: calculation['sunLongitude'] ?? 0.0,
      moonLongitude: calculation['moonLongitude'] ?? 0.0,
      muhurtaIndex: calculation['muhurtaIndex'] ?? 1,
      muhurtaName: calculation['muhurtaName'] ?? '',
      muhurtaIsDay: calculation['muhurtaIsDay'] ?? true,
      muhurtaPeriod: calculation['muhurtaPeriod'] ?? 'Day',
    );
  }

  /// Get a brief description of the date
  String get brief {
    return '$tithiName $paksha, $lunarMonth, $nakshatraName';
  }

  /// Get a detailed description of the date
  String get detailed {
    return '''$gregorianDay/${gregorianMonth.toString().padLeft(2, '0')}/$gregorianYear (Gregorian)
$tithiName $paksha, $lunarMonth $hinduYear
$nakshatraName Nakshatra, $yogaName Yoga, $karanaName Karana
$varaName, $rituName, $masaName''';
  }

  /// Convert to a map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'gregorianYear': gregorianYear,
      'gregorianMonth': gregorianMonth,
      'gregorianDay': gregorianDay,
      'lunarMonth': lunarMonth,
      'lunarMonthNumber': lunarMonthNumber,
      'paksha': paksha,
      'tithiNumber': tithiNumber,
      'tithiName': tithiName,
      'nakshatraNumber': nakshatraNumber,
      'nakshatraName': nakshatraName,
      'yogaNumber': yogaNumber,
      'yogaName': yogaName,
      'karanaNumber': karanaNumber,
      'karanaName': karanaName,
      'varaNumber': varaNumber,
      'varaName': varaName,
      'rituName': rituName,
      'masaName': masaName,
      'hinduYear': hinduYear,
      'julianDay': julianDay,
      'sunLongitude': sunLongitude,
      'moonLongitude': moonLongitude,
      'muhurtaIndex': muhurtaIndex,
      'muhurtaName': muhurtaName,
      'muhurtaIsDay': muhurtaIsDay,
      'muhurtaPeriod': muhurtaPeriod,
    };
  }

  @override
  String toString() {
    return brief;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PancangaDate &&
        other.gregorianYear == gregorianYear &&
        other.gregorianMonth == gregorianMonth &&
        other.gregorianDay == gregorianDay;
  }

  @override
  int get hashCode {
    return Object.hash(gregorianYear, gregorianMonth, gregorianDay);
  }
}
