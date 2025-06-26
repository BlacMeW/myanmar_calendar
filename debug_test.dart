import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';

void main() {
  test('Debug JDN conversion issue', () {
    // Test conversion: 2000-01-01
    print('Testing Gregorian to JDN conversion for 2000-01-01:');
    double jdn = MyanmarCalendarCore.gregorianToJdn(2000, 1, 1);
    print('JDN result: $jdn');

    print('\nTesting JDN to Gregorian conversion for JDN $jdn:');
    List<int> gregorian = MyanmarCalendarCore.jdnToGregorian(jdn);
    print('Gregorian result: ${gregorian[0]}-${gregorian[1]}-${gregorian[2]}');

    print('\nTesting with the exact JDN value 2451544.5:');
    List<int> gregorian2 = MyanmarCalendarCore.jdnToGregorian(2451544.5);
    print('Gregorian result: ${gregorian2[0]}-${gregorian2[1]}-${gregorian2[2]}');
  });
}
