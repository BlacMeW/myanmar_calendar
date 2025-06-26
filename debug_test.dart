import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_calendar/myanmar_calendar.dart';

void main() {
  test('Debug Myanmar conversion', () {
    // Test a known conversion: 2023-04-13 (Thingyan New Year)
    DateTime gregorian = DateTime(2023, 4, 13);
    MyanmarDate myanmar = MyanmarCalendarConverter.gregorianToMyanmar(gregorian);

    print('Gregorian: $gregorian');
    print('Myanmar Year: ${myanmar.year}');
    print('Myanmar Month: ${myanmar.month}');
    print('Myanmar Day: ${myanmar.day}');
    print('Month Name: ${myanmar.monthName}');

    // This should help us understand what the actual values are
    expect(myanmar.year, isA<int>());
  });
}
