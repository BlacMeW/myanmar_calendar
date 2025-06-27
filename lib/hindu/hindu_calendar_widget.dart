/// Hindu Calendar Widget for Flutter
///
/// A comprehensive Hindu calendar widget that displays traditional
/// Hindu/Panchanga calendar information including tithi, nakshatra,
/// yoga, karana, and more.
library;

import 'package:flutter/material.dart';

import 'hcalendar/calculation_engine.dart';
import 'hcalendar/pancanga_date.dart';

/// A widget that displays Hindu calendar information
class HinduCalendarWidget extends StatefulWidget {
  /// Gregorian year
  final int year;

  /// Gregorian month (1-12)
  final int month;

  /// Gregorian day
  final int day;

  /// Whether to show compact view
  final bool compact;

  /// Font size for the text
  final double fontSize;

  /// Latitude for location-based calculations
  final double latitude;

  /// Longitude for location-based calculations
  final double longitude;

  /// Whether to show converter interface
  final bool showConverter;

  const HinduCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    this.compact = false,
    this.fontSize = 16.0,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.showConverter = false,
  });

  @override
  State<HinduCalendarWidget> createState() => _HinduCalendarWidgetState();
}

class _HinduCalendarWidgetState extends State<HinduCalendarWidget> {
  late PancangaDate pancangaDate;

  // Converter state
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = 1;
  int _selectedDay = 1;
  bool _isShukla = true;

  @override
  void initState() {
    super.initState();
    _calculateDate();
  }

  @override
  void didUpdateWidget(HinduCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year ||
        oldWidget.month != widget.month ||
        oldWidget.day != widget.day) {
      _calculateDate();
    }
  }

  void _calculateDate() {
    final calculation = HinduCalculationEngine.calculateHinduDate(
      widget.year,
      widget.month,
      widget.day,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    setState(() {
      pancangaDate = PancangaDate.fromCalculation(calculation);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showConverter) {
      return _buildConverterView();
    }

    return widget.compact ? _buildCompactView() : _buildFullView();
  }

  Widget _buildCompactView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50,
            Colors.deepOrange.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with enhanced design
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade600,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: widget.fontSize,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hindu Panchanga',
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Main tithi display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepOrange.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    '${pancangaDate.tithiName}',
                    style: TextStyle(
                      fontSize: widget.fontSize + 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    pancangaDate.paksha,
                    style: TextStyle(
                      fontSize: widget.fontSize - 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            
            // Panchanga details in chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildInfoChip('⭐ ${pancangaDate.nakshatraName}', Colors.purple),
                _buildInfoChip('🧘 ${pancangaDate.yogaName}', Colors.blue),
                _buildInfoChip('📅 ${pancangaDate.varaName}', Colors.green),
              ],
            ),
            const SizedBox(height: 8),
            
            // Date info
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip('🌙 ${pancangaDate.lunarMonth}', Colors.indigo),
                ),
                const SizedBox(width: 6),
                _buildInfoChip('${pancangaDate.hinduYear}', Colors.orange),
              ],
            ),
            
            // Muhurta info
            if (pancangaDate.muhurtaName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pancangaDate.muhurtaIsDay ? Icons.wb_sunny : Icons.nights_stay,
                      size: widget.fontSize - 2,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Muhurta: ${pancangaDate.muhurtaName}',
                      style: TextStyle(
                        fontSize: widget.fontSize - 2,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: widget.fontSize - 3,
          fontWeight: FontWeight.w500,
          color: color.shade700,
        ),
      ),
    );
  }

  Widget _buildFullView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade50,
            Colors.deepOrange.shade50,
            Colors.red.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDateDisplay(),
            const SizedBox(height: 20),
            _buildPancangaDetails(),
            const SizedBox(height: 20),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade600, Colors.orange.shade500],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: widget.fontSize + 2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hindu Panchanga',
                  style: TextStyle(
                    fontSize: widget.fontSize + 4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Sacred Time Calculation',
                  style: TextStyle(
                    fontSize: widget.fontSize - 2,
                    color: Colors.white.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.star_border,
              color: Colors.white,
              size: widget.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Column(
        children: [
          // Hindu Date
          Text(
            '${pancangaDate.tithiName} ${pancangaDate.paksha}',
            style: TextStyle(
              fontSize: widget.fontSize + 4,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '${pancangaDate.lunarMonth} ${pancangaDate.hinduYear}',
            style: TextStyle(
              fontSize: widget.fontSize + 2,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Gregorian Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Gregorian: ${widget.day}/${widget.month}/${widget.year}',
              style: TextStyle(fontSize: widget.fontSize, color: Colors.deepPurple.shade800),
            ),
          ),

          const SizedBox(height: 8),

          // Key Panchanga at a glance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickInfo('Nakshatra', pancangaDate.nakshatraName),
              _buildQuickInfo('Yoga', pancangaDate.yogaName),
              _buildQuickInfo('Karana', pancangaDate.karanaName),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: widget.fontSize - 3,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: widget.fontSize - 2, color: Colors.deepPurple.shade800),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPancangaDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panchanga Details (Five Limbs of Time)',
          style: TextStyle(fontSize: widget.fontSize + 2, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Core Panchanga Elements
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.deepPurple.shade200),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                '1. Tithi (Lunar Day)',
                '${pancangaDate.tithiName} (${pancangaDate.tithiNumber}) - ${pancangaDate.paksha} Paksha',
              ),
              _buildDetailRow(
                '2. Vara (Weekday)',
                '${pancangaDate.varaName} (${pancangaDate.varaNumber + 1})',
              ),
              _buildDetailRow(
                '3. Nakshatra (Lunar Mansion)',
                '${pancangaDate.nakshatraName} (${pancangaDate.nakshatraNumber})',
              ),
              _buildDetailRow(
                '4. Yoga (Sun-Moon Combination)',
                '${pancangaDate.yogaName} (${pancangaDate.yogaNumber})',
              ),
              _buildDetailRow(
                '5. Karana (Half Tithi)',
                '${pancangaDate.karanaName} (${pancangaDate.karanaNumber})',
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Additional Calendar Information
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar Information',
                style: TextStyle(
                  fontSize: widget.fontSize + 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Hindu Year', pancangaDate.hinduYear.toString()),
              _buildDetailRow('Lunar Month', pancangaDate.lunarMonth),
              _buildDetailRow('Season (Ritu)', pancangaDate.rituName),
              _buildDetailRow('Solar Month (Masa)', pancangaDate.masaName),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: widget.fontSize, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.blue.shade800, size: widget.fontSize),
              const SizedBox(width: 6),
              Text(
                'Astronomical Information',
                style: TextStyle(
                  fontSize: widget.fontSize + 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sun Longitude:',
                      style: TextStyle(fontSize: widget.fontSize - 2, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${pancangaDate.sunLongitude.toStringAsFixed(2)}°',
                      style: TextStyle(fontSize: widget.fontSize - 1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Moon Longitude:',
                      style: TextStyle(fontSize: widget.fontSize - 2, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${pancangaDate.moonLongitude.toStringAsFixed(2)}°',
                      style: TextStyle(fontSize: widget.fontSize - 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Julian Day:',
                      style: TextStyle(fontSize: widget.fontSize - 2, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      pancangaDate.julianDay.toStringAsFixed(2),
                      style: TextStyle(fontSize: widget.fontSize - 1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(fontSize: widget.fontSize - 2, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${widget.latitude.toStringAsFixed(2)}°N, ${widget.longitude.toStringAsFixed(2)}°E',
                      style: TextStyle(fontSize: widget.fontSize - 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Note: Calculations based on standard Hindu calendar algorithms. For precise religious observances, consult local authorities.',
            style: TextStyle(
              fontSize: widget.fontSize - 3,
              fontStyle: FontStyle.italic,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConverterView() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hindu Calendar Converter',
              style: TextStyle(
                fontSize: widget.fontSize + 4,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Current date display
            _buildDateDisplay(),

            const SizedBox(height: 16),

            // Converter inputs
            Text(
              'Convert Hindu Date to Gregorian',
              style: TextStyle(fontSize: widget.fontSize + 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Year',
                    _selectedYear,
                    List.generate(50, (i) => pancangaDate.hinduYear - 25 + i),
                    (value) => setState(() => _selectedYear = value as int),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    'Month',
                    _selectedMonth.clamp(1, 12),
                    List.generate(12, (i) => i + 1),
                    (value) => setState(() => _selectedMonth = value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    'Day',
                    _selectedDay.clamp(1, 15),
                    List.generate(15, (i) => i + 1),
                    (value) => setState(() => _selectedDay = value!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Text('Paksha: ', style: TextStyle(fontSize: widget.fontSize)),
                Radio<bool>(
                  value: true,
                  groupValue: _isShukla,
                  onChanged: (value) => setState(() => _isShukla = value!),
                ),
                const Text('Shukla'),
                Radio<bool>(
                  value: false,
                  groupValue: _isShukla,
                  onChanged: (value) => setState(() => _isShukla = value!),
                ),
                const Text('Krishna'),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _convertHinduToGregorian,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Convert to Gregorian'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, T value, List<T> items, void Function(T?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: widget.fontSize - 2, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((T item) {
            return DropdownMenuItem<T>(value: item, child: Text(item.toString()));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _convertHinduToGregorian() {
    final gregorianDate = HinduCalculationEngine.hinduToGregorian(
      _selectedYear,
      _selectedMonth,
      _selectedDay,
      _isShukla,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conversion Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hindu Date: $_selectedDay ${_isShukla ? 'Shukla' : 'Krishna'} Month $_selectedMonth Year $_selectedYear',
            ),
            const SizedBox(height: 8),
            Text(
              'Gregorian Date: ${gregorianDate.day}/${gregorianDate.month}/${gregorianDate.year}',
            ),
            const SizedBox(height: 8),
            const Text(
              'Note: This is an approximate conversion. Exact conversion requires precise astronomical calculations.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
