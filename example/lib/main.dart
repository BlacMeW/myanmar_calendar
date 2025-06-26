import 'package:flutter/material.dart';
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';

void main() {
  runApp(const MyanmarCalendarExampleApp());
}

class MyanmarCalendarExampleApp extends StatelessWidget {
  const MyanmarCalendarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myanmar Calendar Example',
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Roboto'),
      home: const MyanmarCalendarHome(),
    );
  }
}

class MyanmarCalendarHome extends StatefulWidget {
  const MyanmarCalendarHome({super.key});

  @override
  State<MyanmarCalendarHome> createState() => _MyanmarCalendarHomeState();
}

class _MyanmarCalendarHomeState extends State<MyanmarCalendarHome> {
  DateTime selectedDate = DateTime.now();
  MyanmarDate? myanmarDate;

  @override
  void initState() {
    super.initState();
    _convertDate();
  }

  void _convertDate() {
    setState(() {
      myanmarDate = MyanmarCalendarConverter.gregorianToMyanmar(selectedDate);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _convertDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Myanmar Calendar Library'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Selected: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Change Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Myanmar Calendar Widget
            if (myanmarDate != null) ...[
              const Text(
                'Myanmar Calendar Widget',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              MyanmarCalendarWidget(
                year: selectedDate.year,
                month: selectedDate.month,
                day: selectedDate.day,
                compact: false,
              ),

              const SizedBox(height: 16),

              // Compact Version
              const Text(
                'Compact Version',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              MyanmarCalendarWidget(
                year: selectedDate.year,
                month: selectedDate.month,
                day: selectedDate.day,
                compact: true,
                fontSize: 16,
              ),

              const SizedBox(height: 16),

              // Date Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Gregorian Date:',
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      _buildInfoRow('Myanmar Date:', myanmarDate!.fullDateString),
                      _buildInfoRow('Myanmar Year:', myanmarDate!.year.toString()),
                      _buildInfoRow('Myanmar Month:', myanmarDate!.monthName),
                      _buildInfoRow('Myanmar Day:', myanmarDate!.day.toString()),
                      _buildInfoRow(
                        'Day Name:',
                        MyanmarCalendarConverter.getMyanmarDayName(myanmarDate!),
                      ),
                      _buildInfoRow(
                        'Is Watat Year:',
                        MyanmarCalendarConverter.isWatatYear(myanmarDate!.year) ? 'Yes' : 'No',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Today's Information
              FutureBuilder<MyanmarDate>(
                future: Future.value(MyanmarCalendarConverter.getMyanmarToday()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    MyanmarDate today = snapshot.data!;
                    return Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Myanmar Date',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              today.fullDateString,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Day: ${MyanmarCalendarConverter.getMyanmarDayName(today)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),

              const SizedBox(height: 16),

              // Month Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Myanmar Month: ${myanmarDate!.monthName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<Map<String, dynamic>>(
                        future: Future.value(
                          MyanmarCalendarConverter.getMyanmarCalendarMonth(
                            myanmarDate!.year,
                            myanmarDate!.month,
                          ),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> monthData = snapshot.data!;
                            List<dynamic> days = monthData['days'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total days: ${days.length}'),
                                Text('Is Watat Year: ${monthData['isWatatYear'] ? 'Yes' : 'No'}'),
                                Text(
                                  'Is Intercalary Month: ${monthData['isIntercalaryMonth'] ? 'Yes' : 'No'}',
                                ),
                                const SizedBox(height: 8),
                                const Text('First few days of the month:'),
                                ...days.take(5).map((day) {
                                  MyanmarDate mDay = day['myanmarDate'];
                                  DateTime gDay = day['gregorianDate'];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                    child: Text(
                                      '${mDay.day} - ${gDay.day}/${gDay.month}/${gDay.year}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }),
                              ],
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Usage Examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Library Features',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text('✓ Convert between Gregorian and Myanmar calendars'),
                    const Text('✓ Myanmar calendar widget (compact and full)'),
                    const Text('✓ Support for watat (intercalary) years'),
                    const Text('✓ Myanmar month and day names'),
                    const Text('✓ Full moon, waxing, and waning moon phases'),
                    const Text('✓ Date range conversions'),
                    const Text('✓ Myanmar holidays and special days'),
                    const Text('✓ Day of week in Myanmar'),
                    const SizedBox(height: 12),
                    const Text(
                      'Import: import \'package:myanmar_calendar/myanmar_calendar.dart\';',
                      style: TextStyle(fontFamily: 'monospace', backgroundColor: Color(0xFFF5F5F5)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
