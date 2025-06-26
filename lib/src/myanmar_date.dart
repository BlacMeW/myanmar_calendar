/// Represents a Myanmar calendar date
class MyanmarDate {
  /// Myanmar year
  final int year;

  /// Myanmar month (0-14, where 13-14 are intercalary months)
  final int month;

  /// Myanmar day (1-30)
  final int day;

  /// Day type (0=regular day, 1=waxing moon, 2=full moon, 3=waning moon)
  final int dayType;

  /// Whether this is in an intercalary month
  final bool isIntercalaryMonth;

  const MyanmarDate({
    required this.year,
    required this.month,
    required this.day,
    this.dayType = 0,
    this.isIntercalaryMonth = false,
  });

  /// Myanmar month names
  static const List<String> monthNames = [
    'ပထမ ဝါဆို', // 0: First Waso
    'တန်ခူး', // 1: Tagu
    'ကဆုန်', // 2: Kason
    'နယုန်', // 3: Nayon
    'ဝါဆို', // 4: Waso
    'ဝါခေါင်', // 5: Wagaung
    'တော်သလင်း', // 6: Tawthalin
    'သီတင်းကျွတ်', // 7: Thadingyut
    'တန်ဆောင်မုန်း', // 8: Tazaungmone
    'နတ်တော်', // 9: Natdaw
    'ပြာသို', // 10: Pyatho
    'တပို့တွဲ', // 11: Tabodwe
    'တပေါင်း', // 12: Tabaung
    'နှောင်း တန်ခူး', // 13: Late Tagu (intercalary)
    'နှောင်း ကဆုန်', // 14: Late Kason (intercalary)
  ];

  /// Day names in Myanmar
  static const List<String> dayNames = [
    'တနင်္ဂနွေ', // Sunday
    'တနင်္လာ', // Monday
    'အင်္ဂါ', // Tuesday
    'ဗုဒ္ဓဟူး', // Wednesday
    'ကြာသပတေး', // Thursday
    'သောကြာ', // Friday
    'စနေ', // Saturday
  ];

  /// Get the month name in Myanmar
  String get monthName {
    if (month >= 0 && month < monthNames.length) {
      return monthNames[month];
    }
    return 'Unknown';
  }

  /// Get the formatted day with moon phase
  String get formattedDay {
    String dayStr = _toMyanmarNumber(day);

    if (day < 15) {
      return '$monthName လဆန်း $dayStr ရက်';
    } else if (day == 15) {
      return '$monthName လပြည့်';
    } else {
      int waningDay = day - 15;
      return '$monthName လပြည့်ကျော် ${_toMyanmarNumber(waningDay)} ရက်';
    }
  }

  /// Get full Myanmar date string
  String get fullDateString {
    return '${_toMyanmarNumber(year)} ခု $formattedDay';
  }

  /// Convert English number to Myanmar number
  String _toMyanmarNumber(int number) {
    const Map<String, String> myanmarDigits = {
      '0': '၀',
      '1': '၁',
      '2': '၂',
      '3': '၃',
      '4': '၄',
      '5': '၅',
      '6': '၆',
      '7': '၇',
      '8': '၈',
      '9': '၉',
    };

    return number.toString().split('').map((digit) {
      return myanmarDigits[digit] ?? digit;
    }).join();
  }

  @override
  String toString() {
    return 'MyanmarDate(year: $year, month: $month, day: $day, monthName: $monthName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyanmarDate && other.year == year && other.month == month && other.day == day;
  }

  @override
  int get hashCode {
    return year.hashCode ^ month.hashCode ^ day.hashCode;
  }

  /// Create a copy with optional parameter overrides
  MyanmarDate copyWith({int? year, int? month, int? day, int? dayType, bool? isIntercalaryMonth}) {
    return MyanmarDate(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      dayType: dayType ?? this.dayType,
      isIntercalaryMonth: isIntercalaryMonth ?? this.isIntercalaryMonth,
    );
  }
}
