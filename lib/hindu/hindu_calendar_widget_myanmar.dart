/// Hindu Calendar Widget with Myanmar Language Support
///
/// A comprehensive Hindu calendar widget that displays traditional
/// Hindu/Panchanga calendar information with Myanmar language translations.
library;

import 'package:flutter/material.dart';

import '../hindu/hcalendar/calculation_engine.dart';
import '../hindu/hcalendar/pancanga_date.dart';

/// A widget that displays Hindu calendar information in Myanmar language
class HinduCalendarWidgetMyanmar extends StatefulWidget {
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

  const HinduCalendarWidgetMyanmar({
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
  State<HinduCalendarWidgetMyanmar> createState() => _HinduCalendarWidgetMyanmarState();
}

class _HinduCalendarWidgetMyanmarState extends State<HinduCalendarWidgetMyanmar> {
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
  void didUpdateWidget(HinduCalendarWidgetMyanmar oldWidget) {
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.deepPurple, size: widget.fontSize),
                const SizedBox(width: 6),
                Text(
                  'ဟိန္ဒူ ပြက္ခဒိန်', // Hindu Calendar (Astrology)
                  style: TextStyle(
                    fontSize: widget.fontSize + 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_getMyanmarTithiName(pancangaDate.tithiName)} ${_getMyanmarPaksha(pancangaDate.paksha)}',
              style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'နက္ခတ်: ${_getMyanmarNakshatra(pancangaDate.nakshatraName)}',
                    style: TextStyle(fontSize: widget.fontSize - 2),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ယောဂ: ${_getMyanmarYoga(pancangaDate.yogaName)}',
                    style: TextStyle(fontSize: widget.fontSize - 2),
                  ),
                ),
                Expanded(
                  child: Text(
                    'အပတ်: ${_getMyanmarVara(pancangaDate.varaName)}',
                    style: TextStyle(fontSize: widget.fontSize - 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'လ: ${_getMyanmarMonth(pancangaDate.lunarMonth)}',
                    style: TextStyle(
                      fontSize: widget.fontSize - 2,
                      color: Colors.deepPurple.shade600,
                    ),
                  ),
                ),
                Text(
                  'နှစ်: ${_convertToMyanmarNumerals(pancangaDate.hinduYear)}',
                  style: TextStyle(
                    fontSize: widget.fontSize - 2,
                    color: Colors.deepPurple.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'သံဝစ္စရ: ${_getMyanmarSamvatsara(pancangaDate.hinduYear)}',
              style: TextStyle(
                fontSize: widget.fontSize - 2,
                color: Colors.deepPurple.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'မုဟုတ်တ: ${_getMyanmarMuhurta(pancangaDate.muhurtaName, pancangaDate.muhurtaIsDay)} (${pancangaDate.muhurtaIsDay ? 'နေ့' : 'ည'})',
              style: TextStyle(
                fontSize: widget.fontSize - 2,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullView() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDateDisplay(),
            const SizedBox(height: 16),
            _buildPancangaDetails(),
            const SizedBox(height: 16),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: Colors.deepPurple, size: widget.fontSize + 4),
        const SizedBox(width: 8),
        Text(
          'ဟိန္ဒူ ပြက္ခဒိန် (ပဉ္စာင်္ဂ)', // Hindu Calendar (Panchanga - Astrology)
          style: TextStyle(
            fontSize: widget.fontSize + 4,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
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
            '${_getMyanmarTithiName(pancangaDate.tithiName)} ${_getMyanmarPaksha(pancangaDate.paksha)}',
            style: TextStyle(
              fontSize: widget.fontSize + 4,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '${_getMyanmarMonth(pancangaDate.lunarMonth)} ${_convertToMyanmarNumerals(pancangaDate.hinduYear)}',
            style: TextStyle(
              fontSize: widget.fontSize + 2,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'သံဝစ္စရ: ${_getMyanmarSamvatsara(pancangaDate.hinduYear)}',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple.shade600,
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
              'ဂရီဂေါရီယန်: ${_convertToMyanmarNumerals(widget.day)}/${_convertToMyanmarNumerals(widget.month)}/${_convertToMyanmarNumerals(widget.year)}',
              style: TextStyle(fontSize: widget.fontSize, color: Colors.deepPurple.shade800),
            ),
          ),

          const SizedBox(height: 8),
          // Key Panchanga at a glance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickInfo('နက္ခတ်', _getMyanmarNakshatra(pancangaDate.nakshatraName)),
              _buildQuickInfo('ယောဂ', _getMyanmarYoga(pancangaDate.yogaName)),
              _buildQuickInfo('ကရဏ', _getMyanmarKarana(pancangaDate.karanaName)),
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
          'ပဉ္စာင်္ဂ အသေးစိတ် (အချိန်၏ အင်္ဂါများ)', // Panchanga Details (Limbs of Time)
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
                '၁။ တိထိ',
                '${_getMyanmarTithiName(pancangaDate.tithiName)} (${_convertToMyanmarNumerals(pancangaDate.tithiNumber)}) - ${_getMyanmarPaksha(pancangaDate.paksha)}',
              ),
              _buildDetailRow(
                '၂။ ဝါရ',
                '${_getMyanmarVara(pancangaDate.varaName)} (${_convertToMyanmarNumerals(pancangaDate.varaNumber + 1)})',
              ),
              _buildDetailRow(
                '၃။ နက္ခတ်',
                '${_getMyanmarNakshatra(pancangaDate.nakshatraName)} (${_convertToMyanmarNumerals(pancangaDate.nakshatraNumber)})',
              ),
              _buildDetailRow(
                '၄။ ယောဂ',
                '${_getMyanmarYoga(pancangaDate.yogaName)} (${_convertToMyanmarNumerals(pancangaDate.yogaNumber)})',
              ),
              _buildDetailRow(
                '၅။ ကရဏ',
                '${_getMyanmarKarana(pancangaDate.karanaName)} (${_convertToMyanmarNumerals(pancangaDate.karanaNumber)})',
              ),
              _buildDetailRow(
                '၆။ မုဟုတ်တ',
                '${_getMyanmarMuhurta(pancangaDate.muhurtaName, pancangaDate.muhurtaIsDay)} (${_convertToMyanmarNumerals(pancangaDate.muhurtaIndex)}) - ${pancangaDate.muhurtaIsDay ? 'နေ့ချိန်' : 'ညချိန်'}',
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
                'ပြက္ခဒိန် အချက်အလက်များ',
                style: TextStyle(
                  fontSize: widget.fontSize + 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('နှစ်', _convertToMyanmarNumerals(pancangaDate.hinduYear)),
              _buildDetailRow('လ', _getMyanmarMonth(pancangaDate.lunarMonth)),
              _buildDetailRow('ရတု', _getMyanmarSeason(pancangaDate.rituName)),
              _buildDetailRow('မာသ', _getMyanmarMonth(pancangaDate.masaName)),
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
                'တွက်ချက်မှုများ',
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
                      'ရဝိ',
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
                      'စန္ဒရ',
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
                      'ဂျူလီယန် နေ့:',
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
                      'တည်နေရာ:',
                      style: TextStyle(fontSize: widget.fontSize - 2, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${widget.latitude.toStringAsFixed(2)}°မြောက်, ${widget.longitude.toStringAsFixed(2)}°အရှေ့',
                      style: TextStyle(fontSize: widget.fontSize - 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'မှတ်ချက်: ဤတွက်ချက်မှုများသည် ပုံမှန် ဟိန္ဒူ ပြက္ခဒိန် နည်းလမ်းများပေါ် အခြေခံထားသည်။ တိကျသော ဘာသာရေး ကြည်ညိုမှုများအတွက် ဒေသခံ ဆရာတော်များနှင့် တိုင်ပင်ပါ။',
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
              'ဟိန္ဒူ ပြက္ခဒိန်',
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
              'ဟိန္ဒူ ရက်စွဲကို ဂရီဂေါရီယန်သို့ ပြောင်းလဲရန်',
              style: TextStyle(fontSize: widget.fontSize + 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'နှစ်',
                    _selectedYear,
                    List.generate(50, (i) => pancangaDate.hinduYear - 25 + i),
                    (value) => setState(() => _selectedYear = value as int),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    'လ',
                    _selectedMonth.clamp(1, 12),
                    List.generate(12, (i) => i + 1),
                    (value) => setState(() => _selectedMonth = value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    'ရက်',
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
                Text('ပက္ခ: ', style: TextStyle(fontSize: widget.fontSize)),
                Radio<bool>(
                  value: true,
                  groupValue: _isShukla,
                  onChanged: (value) => setState(() => _isShukla = value!),
                ),
                const Text('လဆန်း ပက္ခ'),
                Radio<bool>(
                  value: false,
                  groupValue: _isShukla,
                  onChanged: (value) => setState(() => _isShukla = value!),
                ),
                const Text('လဆုတ် ပက္ခ'),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _convertHinduToGregorian,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('ဂရီဂေါရီယန်သို့ ပြောင်းရန်'),
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
            return DropdownMenuItem<T>(
              value: item,
              child: Text(_convertToMyanmarNumerals(item as int)),
            );
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
        title: const Text('ပြောင်းလဲမှု ရလဒ်'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ဟိန္ဒူ ရက်စွဲ: ${_convertToMyanmarNumerals(_selectedDay)} ${_isShukla ? 'ရှုကလပက္ခ' : 'ကၖိရှ္ဏပက္ခ'} လ ${_convertToMyanmarNumerals(_selectedMonth)} နှစ် ${_convertToMyanmarNumerals(_selectedYear)}',
            ),
            const SizedBox(height: 8),
            Text(
              'ဂရီဂေါရီယန် ရက်စွဲ: ${_convertToMyanmarNumerals(gregorianDate.day)}/${_convertToMyanmarNumerals(gregorianDate.month)}/${_convertToMyanmarNumerals(gregorianDate.year)}',
            ),
            const SizedBox(height: 8),
            const Text(
              'မှတ်ချက်: ဤသည် ခန့်မှန်းတွက်ချက်မှု ဖြစ်သည်။ တိကျသော ပြောင်းလဲမှုအတွက် တိကျသော နက္ခတ္တရာဇ် တွက်ချက်မှုများ လိုအပ်သည်။',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  // Myanmar translation helper methods
  String _getMyanmarTithiName(String tithiName) {
    const Map<String, String> tithiTranslations = {
      'Pratipada': 'ပထမ',
      'Dwitiya': 'ဒွိတိယာ',
      'Tritiya': 'တြိတိယာ',
      'Chaturthi': 'စတုတ္တီ',
      'Panchami': 'ပဥ္စမီ',
      'Shashthi': 'ဆဋ္ဌမီ',
      'Saptami': 'သတ္တမီ',
      'Ashtami': 'အဋ္ဌမီ',
      'Navami': 'နဝမီ',
      'Dashami': 'ဒဿမီ',
      'Ekadashi': 'ဧကဿီ',
      'Dwadashi': 'ဒွါဒဿီ',
      'Trayodashi': 'တြရိုဒဿီ',
      'Chaturdashi': 'စတုဒ္ဒဿီ',
      'Purnima': 'ပုဏ္ဏမီ (လပြည့်)',
      'Amavasya': 'အမာဝသီ (လကွယ်)',
    };
    return tithiTranslations[tithiName] ?? tithiName;
  }

  String _getMyanmarPaksha(String paksha) {
    const Map<String, String> pakshaTranslations = {'Shukla': 'သုကလပက္ခ', 'Krishna': 'ကဏှပက္ခ'};
    return pakshaTranslations[paksha] ?? paksha;
  }

  String _getMyanmarVara(String vara) {
    const Map<String, String> varaTranslations = {
      'Ravivar': 'တနင်္ဂနွေ',
      'Somvar': 'တနင်္လာ',
      'Mangalvar': 'အင်္ဂါ',
      'Budhvar': 'ဗုဒ္ဓဟူး',
      'Guravar': 'ကြာသပတေး',
      'Shukravar': 'သောကြာ',
      'Shanivar': 'စနေ',
    };
    return varaTranslations[vara] ?? vara;
  }

  String _getMyanmarNakshatra(String nakshatra) {
    const Map<String, String> nakshatraTranslations = {
      'Ashwini': 'အဿဝဏီ',
      'Bharani': 'ဘရဏီ',
      'Krittika': 'ကြတ္တိကာ',
      'Rohini': 'ရောဟဏီ',
      'Mrigashirsha': 'မိဂသီ',
      'Ardra': 'အဒြ',
      'Punarvasu': 'ပုဏ္ဏဖုသျှ',
      'Pushya': 'ဖုသျှ',
      'Ashlesha': 'အသလိဿ',
      'Magha': 'မာဃ',
      'Purva Phalguni': 'ပြုဗ္ဗာ ဘရဂုဏ္ဏီ',
      'Uttara Phalguni': 'ဥတ္တရာဘရဂုဏ္ဏီ',
      'Hasta': 'ဟဿဒ',
      'Chitra': 'စိတြ',
      'Swati': 'သွာတိ',
      'Vishakha': 'ဝိသာခါ',
      'Anuradha': 'အနုရာဓ',
      'Jyeshtha': 'ဇေဋ္ဌ',
      'Mula': 'မူလ',
      'Purva Ashadha': 'ပြုဗ္ဗါသဠ်',
      'Uttara Ashadha': 'ဥတ္တရာသဠ်',
      'Shravana': 'သရဝဏ်',
      'Dhanishtha': 'ဓနသိဒ္ဓ',
      'Shatabhisha': 'သတ္တဘိသျှ',
      'Purva Bhadrapada': 'ပြုဗ္ဗာ ပုရပိုက်',
      'Uttara Bhadrapada': 'ဥတ္တရာ ပုရပိုက်',
      'Revati': 'ရေဝတီ',
    };
    return nakshatraTranslations[nakshatra] ?? nakshatra;
  }

  String _getMyanmarYoga(String yoga) {
    const Map<String, String> yogaTranslations = {
      'Vishkambha': 'ဝီသကမ္ဘ',
      'Priti': 'ပီတိ',
      'Ayushman': 'အာယုသ္မာန်',
      'Saubhagya': 'သောဘဇ',
      'Shobhana': 'သောဘဏ',
      'Atiganda': 'အတိဂဏ္ဍ',
      'Sukarma': 'သုကမ္မ',
      'Dhriti': 'ဓီတိ',
      'Shula': 'သူလ',
      'Ganda': 'ကဏ္ဍ',
      'Vriddhi': 'ဝုဒ္ဓိ',
      'Dhruva': 'ဓူဝ',
      'Vyaghata': 'ဗျာဃတ',
      'Harshana': 'ဟသဏ',
      'Vajra': 'ဝဇီရ',
      'Siddhi': 'သိဒ္ဓိ',
      'Vyatipata': 'ဗျတိပါတ',
      'Variyana': 'ဝီရိယ',
      'Parigha': 'ပရီဃ',
      'Shiva': 'သီဝ',
      'Siddha': 'သိဒ္ဓ',
      'Sadhya': 'သာဓျ',
      'Shubha': 'သုဘ',
      'Shukla': 'သုတ္တ',
      'Brahma': 'ဗြဟ္မ',
      'Indra': 'ဣန္ဒ',
      'Vaidhriti': 'ဝေဓရိ',
    };
    return yogaTranslations[yoga] ?? yoga;
  }

  String _getMyanmarKarana(String karana) {
    const Map<String, String> karanaTranslations = {
      'Bava': 'ဗဗ',
      'Balava': 'ဗလဝ',
      'Kaulava': 'ကောလဝါ',
      'Taitila': 'တေထိလ',
      'Gara': 'ဂရဇံ',
      'Vanija': 'ဝဏိဇ',
      'Vishti': 'ဗိဋ္ဌိ',
      'Shakuni': 'သကုနိ',
      'Chatushpada': 'စတုပါဒ',
      'Naga': 'နာဂ',
      'Kimstughna': 'ကိတုဃန',
    };
    return karanaTranslations[karana] ?? karana;
  }

  String _getMyanmarMonth(String month) {
    const Map<String, String> monthTranslations = {
      'Chaitra': 'စိတြ (မတ်-ဧပြီ)',
      'Vaisakha': 'ဝိသာခ (ဧပြီ-မေ)',
      'Jyaistha': 'ဇေဋ္ဌ (မေ-ဇွန်)',
      'Ashadha': 'အာသဠှ (ဇွန်-ဇူလိုင်)',
      'Shravana': 'သရဝဏ်(ဇူလိုင်-သြဂုတ်)',
      'Bhadrapada': 'ဘဒြ (သြဂုတ်-စက်တင်ဘာ)',
      'Ashvina': 'အဿဝဏီ (စက်တင်ဘာ-အောက်တိုဘာ)',
      'Kartika': 'ကြတ္တိကာ (အောက်တိုဘာ-နိုဝင်ဘာ)',
      'Agrahayana': 'အဒြ (နိုဝင်ဘာ-ဒီဇင်ဘာ)',
      'Pausha': 'ဖုသျှ (ဒီဇင်ဘာ-ဇန်နဝါရီ)',
      'Magha': 'မာဃ (ဇန်နဝါရီ-ဖေဖော်ဝါရီ)',
      'Phalguna': 'ဘရဂုဏ္ဏီ (ဖေဖော်ဝါရီ-မတ်)',
    };
    return monthTranslations[month] ?? month;
  }

  String _getMyanmarSeason(String season) {
    const Map<String, String> seasonTranslations = {
      'Vasanta': 'ဝသန္တ (နွေဦးရာသီ)',
      'Grishma': 'ဂိမှနရတု(နွေရာသီ)',
      'Varsha': 'ဝဿာနရတု (မိုးရာသီ)',
      'Sharad': 'သရဒရတု (ဆောင်းဦးရာသီ)',
      'Shishira': 'သိသိရ (ဆောင်းရာသီ)',
      'Hemanta': 'ဟေမန္တ(ဆောင်းနှောင်းရာသီ)',
    };
    return seasonTranslations[season] ?? season;
  }

  String _getMyanmarSamvatsara(int hinduYear) {
    // 60-year Samvatsara cycle names in Myanmar
    const List<String> samvatsaraNames = [
      'ပြဗ (Prabha)', // 1. Prabhava
      'ဝိဘဝ (Vibhava)', // 2. Vibhava
      'သုကလ (Shukla)', // 3. Shukla
      'ပြမောဒုတ (Pramoduta)', // 4. Pramoduta
      'ပြဇာပတိ (Prajapati)', // 5. Prajapati
      'အင်္ဂီရသ (Angirasa)', // 6. Angirasa
      'သြီမုခ (Shrimukha)', // 7. Shrimukha
      'ဘဝ (Bhava)', // 8. Bhava
      'ယုဝ (Yuva)', // 9. Yuva
      'ဓါတ (Dhata)', // 10. Dhata
      'ဤရှွ (Ishvara)', // 11. Ishvara
      'ဗာဟုဓါနျ (Bahudhanya)', // 12. Bahudhanya
      'ပြမာထီ (Pramathi)', // 13. Pramathi
      'ဝိကြမ (Vikrama)', // 14. Vikrama
      'ဝၖိရ် (Vrisha)', // 15. Vrisha
      'စိတြဘာနု (Chitrabhanu)', // 16. Chitrabhanu
      'သုဗါနု (Subhanu)', // 17. Subhanu
      'တာရဏ (Tarana)', // 18. Tarana
      'ပါတ္တီဝ (Parthiba)', // 19. Parthiba
      'ဗျယ (Vyaya)', // 20. Vyaya
      'သရ္ဝဇိတ (Sarvajit)', // 21. Sarvajit
      'သရ္ဝဓါရီ (Sarvadhari)', // 22. Sarvadhari
      'ဝိရောဓီ (Virodhi)', // 23. Virodhi
      'ဝိကၖတ (Vikrita)', // 24. Vikrita
      'ခရ (Khara)', // 25. Khara
      'နန္ဒန (Nandana)', // 26. Nandana
      'ဝိဇယ (Vijaya)', // 27. Vijaya
      'ဇယ (Jaya)', // 28. Jaya
      'မန္မထ (Manmatha)', // 29. Manmatha
      'ဒုမ္မုခ (Durmukha)', // 30. Durmukha
      'ဟေမလမ္ဗ (Hemalamba)', // 31. Hemalamba
      'ဝိလမ္ဗ (Vilamba)', // 32. Vilamba
      'ဝိကါရီ (Vikari)', // 33. Vikari
      'ရှာရ္ဝရီ (Sharvari)', // 34. Sharvari
      'ပလဝ (Plava)', // 35. Plava
      'သုဘကၖတ (Shubhakrit)', // 36. Shubhakrit
      'သောဘကၖတ (Sobhakrit)', // 37. Sobhakrit
      'ကြောဓီ (Krodhi)', // 38. Krodhi
      'ဝိရွာက္ခ (Vishvavasu)', // 39. Vishvavasu
      'ပရာဘဝ (Parabhava)', // 40. Parabhava
      'ပလဝင်္ဂ (Plavanga)', // 41. Plavanga
      'ကီလက (Kilaka)', // 42. Kilaka
      'သောမျ (Saumya)', // 43. Saumya
      'သာဓါရဏ (Sadharana)', // 44. Sadharana
      'ဝိရောဓကၖတ (Virodhakrit)', // 45. Virodhakrit
      'ပရီဓါဝီ (Paridhavi)', // 46. Paridhavi
      'ပြမာဒီစ (Pramadica)', // 47. Pramadica
      'အာနန္ဒ (Ananda)', // 48. Ananda
      'ရာက္ခသ (Rakshasa)', // 49. Rakshasa
      'နလ (Nala)', // 50. Nala (Anala)
      'ပိင်္ဂလ (Pingala)', // 51. Pingala
      'ကာလယုက္တ (Kalayukta)', // 52. Kalayukta
      'သိဒ္ဓါတ္တ (Siddharthi)', // 53. Siddharthi
      'ရောဒြီ (Raudri)', // 54. Raudri
      'ဒုမ္မတိ (Durmati)', // 55. Durmati
      'ဒုန္ဒုဗီ (Dundubhi)', // 56. Dundubhi
      'ရုဓိရောဒ္ဂါရီ (Rudhirodgari)', // 57. Rudhirodgari
      'ရက္တာက္ခ (Raktakshi)', // 58. Raktakshi
      'ကြောဓန (Krodhana)', // 59. Krodhana
      'က္ခယ (Akshaya)', // 60. Akshaya
    ];

    // Calculate the position in the 60-year cycle
    // Hindu calendar started from 3102 BCE (Kali Yuga)
    int cyclePosition = (hinduYear - 1) % 60;
    return samvatsaraNames[cyclePosition];
  }

  String _convertToMyanmarNumerals(int number) {
    const List<String> myanmarDigits = ['၀', '၁', '၂', '၃', '၄', '၅', '၆', '၇', '၈', '၉'];
    return number.toString().split('').map((digit) {
      int digitInt = int.tryParse(digit) ?? 0;
      return myanmarDigits[digitInt];
    }).join();
  }

  String _getMyanmarDayMuhurta(String muhurtaName) {
    const Map<String, String> dayMuhurtaTranslations = {
      'Rudra': 'ရုဒြ',
      'Ahi': 'သပ္ပ',
      'Mitra': 'မိတြ',
      'Vasu': 'ဝိကရ',
      'Vara': 'ဝသု',
      'Vishwadeva': 'ဥဒက',
      'Abhijit': 'ဝိဿောဒေဝါ',
      'Brahma': 'အဘိဇိတ်',
      'Kunda': 'ဗြဟ္မာ',
      'Indragni': 'ကုန်ဒြ',
      'Rakshasa': 'ဣန္ဒာဂ္နိ',
      'Varuna': 'ရက္ခသ',
      'Aryama': 'ဝရုဏ',
      'Bhaga': 'အယျမာ',
      'Girish': 'ဘဂ',
    };
    return dayMuhurtaTranslations[muhurtaName] ?? muhurtaName;
  }

  String _getMyanmarNightMuhurta(String muhurtaName) {
    const Map<String, String> nightMuhurtaTranslations = {
      'Shiva': 'သိဝ',
      'Ajapada': 'အဇပါက်',
      'Ativunika': 'အတိဗုနိယ',
      'Pushya': 'ပုသျှယ',
      'Ashvinikumara': 'အဿိနိကုမာရ',
      'Dharmaraja': 'ဓမ္မရာဇ',
      'Agni': 'အဂ္ဂိ',
      'Brahma': 'ဗြဟ္မာ',
      'Chandrima': 'စန္ဓိမာ',
      'Aditi': 'အဒိတိ',
      'Brihaspati': 'ဗြိဟပ္ပတိ',
      'Vishnu': 'ဗိဿဏိုး',
      'Surya': 'သူရိယ',
      'Twashta': 'တွဋ္ဌာ',
      'Vayu': 'ဝါယု',
    };
    return nightMuhurtaTranslations[muhurtaName] ?? muhurtaName;
  }

  String _getMyanmarMuhurta(String muhurtaName, bool isDay) {
    return isDay ? _getMyanmarDayMuhurta(muhurtaName) : _getMyanmarNightMuhurta(muhurtaName);
  }
}
