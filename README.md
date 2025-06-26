# Myanmar & Hindu Calendar

A comprehensive Flutter library for Myanmar and Hindu calendar functionality including date conversions, calendar widgets, and traditional calendar calculations with full Panchanga support.

## Features

### Myanmar Calendar
- ✅ **Date Conversion**: Convert between Gregorian and Myanmar calendars
- ✅ **Calendar Widget**: Beautiful Myanmar calendar widget with compact and full modes
- ✅ **Watat Year Support**: Handles intercalary (watat) years correctly
- ✅ **Myanmar Numerals**: Automatic conversion to Myanmar digits
- ✅ **Moon Phases**: Support for waxing, full, and waning moon phases
- ✅ **Day Names**: Myanmar day names and day of week calculation
- ✅ **Month Generation**: Generate complete Myanmar months with Gregorian equivalents
- ✅ **Date Ranges**: Convert ranges of dates between calendars
- ✅ **Holidays**: Get Myanmar holidays and special days
- ✅ **Accurate Algorithm**: Based on traditional Myanmar calendar calculations

### Hindu Calendar (Panchanga)
- ✅ **Panchanga Calculation**: Complete five limbs of time (Tithi, Vara, Nakshatra, Yoga, Karana)
- ✅ **Hindu Calendar Widget**: Beautiful Hindu calendar widget with compact and full modes
- ✅ **Astronomical Calculations**: Sun and Moon longitude calculations
- ✅ **Lunar Months**: Lunar month names and calculations
- ✅ **Paksha Support**: Shukla (bright) and Krishna (dark) fortnight calculations
- ✅ **Seasonal Information**: Ritu (season) calculations
- ✅ **Location Aware**: Supports latitude/longitude for precise calculations
- ✅ **Traditional Names**: Sanskrit names for all calendar elements

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  myanmar_calendar_widget: ^0.2.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Import

```dart
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';
```

### Date Conversion

```dart
// Convert Gregorian to Myanmar
DateTime gregorianDate = DateTime(2023, 4, 13);
MyanmarDate myanmarDate = MyanmarCalendarConverter.gregorianToMyanmar(gregorianDate);
print(myanmarDate.fullDateString); // ၁၃၈၅ ခု တန်ခူး လဆန်း ၁ ရက်

// Convert Myanmar to Gregorian
MyanmarDate myanmar = MyanmarDate(year: 1385, month: 1, day: 15);
DateTime gregorian = MyanmarCalendarConverter.myanmarToGregorian(myanmar);
print(gregorian); // 2023-04-28 00:00:00.000

// Get today's Myanmar date
MyanmarDate today = MyanmarCalendarConverter.getMyanmarToday();
print(today.fullDateString);
```

### Myanmar Calendar Widget

```dart
// Full calendar widget
MyanmarCalendarWidget(
  year: 2023,
  month: 4,
  day: 13,
  compact: false,
)

// Compact calendar widget
MyanmarCalendarWidget(
  year: 2023,
  month: 4,
  day: 13,
  compact: true,
  fontSize: 16,
)
```

### Working with Myanmar Dates

```dart
// Create a Myanmar date
MyanmarDate date = MyanmarDate(
  year: 1385,
  month: 1, // Tagu month
  day: 15,  // Full moon day
);

// Get formatted strings
print(date.monthName);        // တန်ခူး
print(date.formattedDay);     // တန်ခူး လပြည့်
print(date.fullDateString);   // ၁၃၈၅ ခု တန်ခူး လပြည့်

// Get day of week
String dayName = MyanmarCalendarConverter.getMyanmarDayName(date);
print(dayName); // တနင်္ဂနွေ (Sunday)
```

### Calendar Month Generation

```dart
// Get all days in a Myanmar month
List<MyanmarDate> monthDays = MyanmarCalendarConverter.getMyanmarMonth(1385, 1);

// Get month with Gregorian equivalents
Map<String, dynamic> monthData = MyanmarCalendarConverter.getMyanmarCalendarMonth(1385, 1);
print(monthData['monthName']); // တန်ခူး
print(monthData['isWatatYear']); // true/false
List<dynamic> days = monthData['days'];
```

### Watat (Intercalary) Years

```dart
// Check if a year is watat
bool isWatat = MyanmarCalendarConverter.isWatatYear(1385);

// Get days in a specific month (considers watat)
int daysInMonth = MyanmarCalendarConverter.getDaysInMyanmarMonth(1385, 1);
```

### Date Range Conversion

```dart
DateTime start = DateTime(2023, 1, 1);
DateTime end = DateTime(2023, 1, 31);

List<Map<String, dynamic>> conversions = MyanmarCalendarConverter.convertDateRange(start, end);

for (var conversion in conversions) {
  DateTime gregorian = conversion['gregorian'];
  MyanmarDate myanmar = conversion['myanmar'];
  String dayName = conversion['dayName'];

  print('$gregorian -> ${myanmar.fullDateString} ($dayName)');
}
```

### Myanmar Holidays

```dart
// Get holidays for a Myanmar year
List<Map<String, dynamic>> holidays = MyanmarCalendarConverter.getMyanmarHolidays(1385);

for (var holiday in holidays) {
  print('${holiday['name']}: ${holiday['date'].fullDateString}');
}
```

## Myanmar Calendar System

The Myanmar calendar is a lunisolar calendar system that has been used in Myanmar for centuries. Key features:

- **Lunisolar System**: Based on both lunar months and solar years
- **12 Regular Months**: Each month follows lunar cycles (29-30 days)
- **Watat Years**: Intercalary years with an extra month (occurs roughly every 2-3 years)
- **Moon Phases**: Days are categorized by moon phases (waxing, full, waning)
- **Buddhist Era**: Years are counted from the Buddhist era (BE)

### Month Names

1. တန်ခူး (Tagu) - March/April
2. ကဆုန် (Kason) - April/May
3. နယုန် (Nayon) - May/June
4. ဝါဆို (Waso) - June/July
5. ဝါခေါင် (Wagaung) - July/August
6. တော်သလင်း (Tawthalin) - August/September
7. သီတင်းကျွတ် (Thadingyut) - September/October
8. တန်ဆောင်မုန်း (Tazaungmone) - October/November
9. နတ်တော် (Natdaw) - November/December
10. ပြာသို (Pyatho) - December/January
11. တပို့တွဲ (Tabodwe) - January/February
12. တပေါင်း (Tabaung) - February/March

In watat years, there may be additional intercalary months.

## Hindu Calendar (Panchanga) Usage

### Hindu Calendar Widget

```dart
// Basic Hindu calendar widget
HinduCalendarWidget(
  year: 2025,
  month: 6,
  day: 27,
  compact: false, // false for full view, true for compact
)

// With location for precise calculations
HinduCalendarWidget(
  year: 2025,
  month: 6,
  day: 27,
  compact: false,
  latitude: 28.6139, // New Delhi
  longitude: 77.2090,
  fontSize: 16.0,
)

// Compact mode for space-constrained layouts
HinduCalendarWidget(
  year: 2025,
  month: 6,
  day: 27,
  compact: true,
)
```

### Panchanga Information

The Hindu calendar widget provides complete Panchanga information:

1. **Tithi** (Lunar Day): e.g., "Panchami Shukla" (5th day of bright fortnight)
2. **Vara** (Weekday): e.g., "Shanivar" (Saturday)
3. **Nakshatra** (Lunar Mansion): e.g., "Rohini" (4th nakshatra)
4. **Yoga** (Sun-Moon Combination): e.g., "Vishkambha" (1st yoga)
5. **Karana** (Half Tithi): e.g., "Bava" (1st karana)

### Additional Hindu Calendar Features

- **Hindu Year**: Calculated from Gregorian year (approximate)
- **Lunar Month**: Traditional Sanskrit month names
- **Paksha**: Shukla (bright/waxing) or Krishna (dark/waning) fortnight
- **Ritu**: Seasonal information (6 seasons)
- **Astronomical Data**: Sun and Moon longitudes, Julian day
- **Location Support**: Latitude/longitude for precise calculations

## Example

Here's a complete example showing how to use both Myanmar and Hindu Calendar Widgets in your Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myanmar & Hindu Calendar Demo',
      home: const CalendarDemo(),
    );
  }
}

class CalendarDemo extends StatelessWidget {
  const CalendarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Demo')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Myanmar Calendar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            // Myanmar Calendar - Full Mode
            MyanmarCalendarWidget(
              year: 2025,
              month: 6,
              day: 27,
              compact: false,
            ),

            SizedBox(height: 16),

            // Myanmar Calendar - Compact Mode
            MyanmarCalendarWidget(
              year: 2025,
              month: 6,
              day: 27,
              compact: true,
            ),

            SizedBox(height: 24),

            Text('Hindu Calendar (Panchanga)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            // Hindu Calendar - Full Mode
            HinduCalendarWidget(
              year: 2025,
              month: 6,
              day: 27,
              compact: false,
              latitude: 28.6139, // New Delhi coordinates
              longitude: 77.2090,
            ),

            SizedBox(height: 16),

            // Hindu Calendar - Compact Mode
            HinduCalendarWidget(
              year: 2025,
              month: 6,
              day: 27,
              compact: true,
            ),
          ],
        ),
      ),
    );
  }
}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myanmar Calendar Demo',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Get today's Myanmar date
    MyanmarDate myanmarToday = MyanmarCalendarConverter.getMyanmarToday();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Myanmar Calendar Demo'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Display today's Myanmar date
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Today in Myanmar Calendar:'),
                  Text(
                    myanmarToday.fullDateString,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Myanmar Calendar Widget
          MyanmarCalendarWidget(
            year: selectedDate.year,
            month: selectedDate.month,
            day: selectedDate.day,
            compact: false,
          ),

          // Compact version
          const Text('Compact Version:'),
          MyanmarCalendarWidget(
            year: selectedDate.year,
            month: selectedDate.month,
            day: selectedDate.day,
            compact: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

This library implements traditional Myanmar calendar calculations and algorithms used in Myanmar for centuries.
