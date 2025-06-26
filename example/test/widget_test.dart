// This is a basic Flutter widget test.
//
// Widget test for Myanmar Calendar Demo

import 'package:flutter_test/flutter_test.dart';
import 'package:myanmar_calendar_example/complete_calendar_demo.dart';

void main() {
  testWidgets('Calendar demo loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CompleteCalendarDemo());

    // Verify that the app has loaded with expected text
    expect(find.text('Myanmar & Hindu Calendar Demo'), findsOneWidget);
    expect(find.text('Myanmar Calendar'), findsOneWidget);
    expect(find.text('Hindu Calendar'), findsOneWidget);
    expect(find.text('Currently Selected Date'), findsOneWidget);
  });
}
