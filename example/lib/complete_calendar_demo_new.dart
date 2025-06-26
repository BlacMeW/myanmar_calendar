// Complete Calendar Demo
// This demo showcases both Myanmar and Hindu calendar widgets with compact and full versions

import 'package:flutter/material.dart';
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';

void main() {
  runApp(const CompleteCalendarDemo());
}

class CompleteCalendarDemo extends StatelessWidget {
  const CompleteCalendarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myanmar & Hindu Calendar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const CalendarHomePage(),
    );
  }
}

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  State<CalendarHomePage> createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  MyanmarDate? myanmarDate;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _convertDate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text('Myanmar & Hindu Calendar Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Myanmar Calendar'),
            Tab(text: 'Hindu Calendar'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date display and selector - shared between tabs
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade100,
            child: _buildDateDisplay(),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildMyanmarCalendarTab(), _buildHinduCalendarTab()],
            ),
          ),
        ],
      ),
    );
  }

  // Myanmar Calendar Tab
  Widget _buildMyanmarCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Myanmar Calendar Widget
          const Text(
            'Myanmar Calendar - Full Version',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MyanmarCalendarWidget(
            year: selectedDate.year,
            month: selectedDate.month,
            day: selectedDate.day,
            compact: false,
          ),

          const SizedBox(height: 24),

          // Compact Myanmar Calendar Widget
          const Text(
            'Myanmar Calendar - Compact Version',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          MyanmarCalendarWidget(
            year: selectedDate.year,
            month: selectedDate.month,
            day: selectedDate.day,
            compact: true,
          ),

          const SizedBox(height: 24),

          // Myanmar Date Details
          if (myanmarDate != null) ...[
            const Text(
              'Myanmar Date Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          ],

          const SizedBox(height: 24),

          // Usage Information
          const Text(
            'Myanmar Calendar Usage',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Import:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black87,
                    child: const Text(
                      "import 'package:myanmar_calendar_widget/myanmar_calendar.dart';",
                      style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Basic Usage:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black87,
                    child: const Text("""MyanmarCalendarWidget(
  year: 2025,
  month: 6,
  day: 27,
  compact: false,
)""", style: TextStyle(color: Colors.white, fontFamily: 'monospace')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hindu Calendar Tab
  Widget _buildHinduCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Hindu Calendar Widget
          const Text(
            'Hindu Calendar - Full Version',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          HinduCalendarWidget(
            year: selectedDate.year,
            month: selectedDate.month,
            day: selectedDate.day,
            compact: false,
          ),

          const SizedBox(height: 24),

          // Compact Hindu Calendar Widget
          const Text(
            'Hindu Calendar - Compact Version',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          HinduCalendarWidget(
            year: selectedDate.year,
            month: selectedDate.month,
            day: selectedDate.day,
            compact: true,
          ),

          const SizedBox(height: 24),

          // Usage Information
          const Text(
            'Hindu Calendar Usage',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Import:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black87,
                    child: const Text(
                      "import 'package:myanmar_calendar_widget/myanmar_calendar.dart';",
                      style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Basic Usage:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.black87,
                    child: const Text("""HinduCalendarWidget(
  year: 2025,
  month: 6,
  day: 27,
  compact: false,
)""", style: TextStyle(color: Colors.white, fontFamily: 'monospace')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for date display
  Widget _buildDateDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Currently Selected Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Change Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper for info rows
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
