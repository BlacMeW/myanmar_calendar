import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';

void main() {
  group('Myanmar Calendar Library Basic Tests', () {
    test('should create Myanmar date', () {
      MyanmarDate date = const MyanmarDate(year: 1385, month: 1, day: 15);
      expect(date.year, 1385);
      expect(date.monthName, 'တန်ခူး');
    });

    test('should convert between calendars', () {
      DateTime gregorian = DateTime(2023, 4, 13);
      MyanmarDate myanmar = MyanmarCalendarConverter.gregorianToMyanmar(gregorian);
      expect(myanmar.year, greaterThan(1380));

      DateTime converted = MyanmarCalendarConverter.myanmarToGregorian(myanmar);
      expect(converted, isA<DateTime>());
    });

    test('should get today Myanmar date', () {
      MyanmarDate today = MyanmarCalendarConverter.getMyanmarToday();
      expect(today.year, greaterThan(1380));
    });

    test('should format Myanmar numbers', () {
      MyanmarDate date = const MyanmarDate(year: 1385, month: 1, day: 1);
      expect(date.fullDateString.contains('၁၃၈၅'), true);
    });
  });
}
