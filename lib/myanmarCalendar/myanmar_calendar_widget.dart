import 'package:flutter/material.dart';

class MyanmarCalendarWidget extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final bool compact;
  final double? fontSize;

  const MyanmarCalendarWidget({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    this.compact = false,
    this.fontSize,
  });

  @override
  State<MyanmarCalendarWidget> createState() => _MyanmarCalendarWidgetState();
}

class _MyanmarCalendarWidgetState extends State<MyanmarCalendarWidget> {
  bool _showConversion = false;
  bool _isMyanmarToGregorian = true;

  late int _gregorianYear;
  late int _gregorianMonth;
  late int _gregorianDay;

  late int _myanmarYear;
  late int _myanmarMonth;
  late int _myanmarDay;

  final TextEditingController _myanmarDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gregorianYear = widget.year;
    _gregorianMonth = widget.month;
    _gregorianDay = widget.day;

    final myanmarDate = _MyanmarCalendarWidgetState.j2m(
      modernDateToJulianDay(_gregorianYear, _gregorianMonth, _gregorianDay),
    );
    _myanmarYear = myanmarDate[1];
    _myanmarMonth = myanmarDate[2];
    _myanmarDay = myanmarDate[3];
    _myanmarDayController.text = _myanmarDay.toString();
  }

  @override
  void dispose() {
    _myanmarDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final julianDay = modernDateToJulianDay(widget.year, widget.month, widget.day);
    final myanmarDate = _MyanmarCalendarWidgetState.j2m(julianDay);
    // final int myt = myanmarDate[0]; // Myanmar year type (not displayed in basic widget)
    final int my = myanmarDate[1];
    final int mm = myanmarDate[2];
    final int md = myanmarDate[3];

    const myanmarMonths = [
      'ပထမ ဝါဆို',
      'တန်ခူး',
      'ကဆုန်',
      'နယုန်',
      'ဝါဆို',
      'ဝါခေါင်',
      'တော်သလင်း',
      'သီတင်းကျွတ်',
      'တန်ဆောင်မုန်း',
      'နတ်တော်',
      'ပြာသို',
      'တပို့တွဲ',
      'တပေါင်း',
      'နှောင်း တန်ခူး',
      'နှောင်း ကဆုန်',
    ];

    String myanmarMonthBase = (mm >= 0 && mm < myanmarMonths.length)
        ? myanmarMonths[mm]
        : 'Unknown';
    String myanmarMonth;
    int displayMd = md;
    if (md < 15) {
      myanmarMonth = '$myanmarMonthBase လဆန်း';
    } else if (md == 15) {
      myanmarMonth = '$myanmarMonthBase လပြည့်';
    } else {
      displayMd = md - 15;
      myanmarMonth = '$myanmarMonthBase လပြည့်ကျော်';
    }

    // --- Only show compact style if widget.compact is true ---
    if (widget.compact) {
      final double yearFontSize = widget.fontSize ?? 20;
      final double monthFontSize = (widget.fontSize != null) ? widget.fontSize! - 2 : 18;
      final double dayFontSize = widget.fontSize ?? 20;
      return Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _toMyanmarNumber(my),
                style: TextStyle(
                  fontSize: yearFontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyanmarSans',
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                myanmarMonth,
                style: TextStyle(fontSize: monthFontSize, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Text(
                '${_toMyanmarNumber(displayMd)} ရက်',
                style: TextStyle(
                  fontSize: dayFontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MyanmarSans',
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- If not in convertor mode, show compact style with convert button and _isMyanmarToGregorian swap ---
    if (!_showConversion && !widget.compact) {
      final double yearFontSize = widget.fontSize ?? 20;
      final double monthFontSize = (widget.fontSize != null) ? widget.fontSize! - 2 : 18;
      final double dayFontSize = widget.fontSize ?? 20;
      return Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Compact Myanmar or Gregorian calendar info (controlled by _isMyanmarToGregorian)
              _isMyanmarToGregorian
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _toMyanmarNumber(my),
                          style: TextStyle(
                            fontSize: yearFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyanmarSans',
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          myanmarMonth,
                          style: TextStyle(fontSize: monthFontSize, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_toMyanmarNumber(displayMd)} ရက်',
                          style: TextStyle(
                            fontSize: dayFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyanmarSans',
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _gregorianYear.toString().padLeft(4, '0'),
                          style: TextStyle(
                            fontSize: yearFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _gregorianMonthName(_gregorianMonth),
                          style: TextStyle(fontSize: monthFontSize, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _gregorianDay.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: dayFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
              // Show swap and convert button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    tooltip: _isMyanmarToGregorian ? 'Myanmar → Gregorian' : 'Gregorian → Myanmar',
                    onPressed: () {
                      setState(() {
                        _isMyanmarToGregorian = !_isMyanmarToGregorian;
                      });
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showConversion = true;
                      });
                    },
                    icon: const Icon(Icons.sync_alt),
                    label: const Text('ပြောင်းရန်'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // --- Full convertor UI ---
    // Note: Myanmar year type information available in myt variable
    // (1 = small year, 2 = big year)

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isMyanmarToGregorian
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _toMyanmarNumber(_myanmarYear),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyanmarSans',
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            myanmarMonths[_myanmarMonth],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${_toMyanmarNumber(_myanmarDay)} ရက်',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyanmarSans',
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _gregorianYear.toString().padLeft(4, '0'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _gregorianMonthName(_gregorianMonth),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _gregorianDay.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      tooltip: _isMyanmarToGregorian
                          ? 'Myanmar → Gregorian'
                          : 'Gregorian → Myanmar',
                      onPressed: () {
                        setState(() {
                          _isMyanmarToGregorian = !_isMyanmarToGregorian;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showConversion = !_showConversion;
                        });
                      },
                      icon: Icon(_showConversion ? Icons.close : Icons.sync_alt),
                      label: Text(_showConversion ? 'ပိတ်မည်' : 'ပြောင်းရန်'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            if (_showConversion)
              _isMyanmarToGregorian
                  ? _buildMyanmarToGregorianConvertor(context)
                  : _buildGregorianToMyanmarConvertor(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMyanmarToGregorianConvertor(BuildContext context) {
    const myanmarMonths = [
      'ပထမ ဝါဆို',
      'တန်ခူး',
      'ကဆုန်',
      'နယုန်',
      'ဝါဆို',
      'ဝါခေါင်',
      'တော်သလင်း',
      'သီတင်းကျွတ်',
      'တန်ဆောင်မုန်း',
      'နတ်တော်',
      'ပြာသို',
      'တပို့တွဲ',
      'တပေါင်း',
      'နှောင်း တန်ခူး',
      'နှောင်း ကဆုန်',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: _myanmarYear.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Myanmar Year'),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) setState(() => _myanmarYear = parsed);
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<int>(
                value: _myanmarMonth,
                items: List.generate(
                  myanmarMonths.length,
                  (i) => DropdownMenuItem(value: i, child: Text(myanmarMonths[i])),
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _myanmarMonth = val);
                },
                decoration: const InputDecoration(labelText: 'Myanmar Month'),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 55,
              child: TextFormField(
                controller: _myanmarDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Day'),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) {
                    if (parsed > 30) {
                      setState(() => _myanmarDay = 30);
                    } else if (parsed < 1) {
                      setState(() => _myanmarDay = 1);
                    } else {
                      setState(() => _myanmarDay = parsed);
                    }
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            int jdn = myanmarToJdn(_myanmarYear, _myanmarMonth, _myanmarDay);
            var gregorian = jdnToGregorian(jdn.toDouble());
            int year = gregorian[0];
            int month = gregorian[1];
            int day = gregorian[2];
            final monthNames = [
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December',
            ];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gregorian Date: $day ${monthNames[month - 1]} $year',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ISO Format: $year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGregorianToMyanmarConvertor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: _gregorianYear.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Year'),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) setState(() => _gregorianYear = parsed);
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: _gregorianMonth.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Month'),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed >= 1 && parsed <= 12) {
                    setState(() => _gregorianMonth = parsed);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: _gregorianDay.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Day'),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed >= 1 && parsed <= 31) {
                    setState(() => _gregorianDay = parsed);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final myanmarDate = _MyanmarCalendarWidgetState.j2m(
              modernDateToJulianDay(_gregorianYear, _gregorianMonth, _gregorianDay),
            );
            // final int myt = myanmarDate[0]; // Myanmar year type (unused in this context)
            final int my = myanmarDate[1];
            final int mm = myanmarDate[2];
            final int md = myanmarDate[3];
            const myanmarMonths = [
              'ပထမ ဝါဆို',
              'တန်ခူး',
              'ကဆုန်',
              'နယုန်',
              'ဝါဆို',
              'ဝါခေါင်',
              'တော်သလင်း',
              'သီတင်းကျွတ်',
              'တန်ဆောင်မုန်း',
              'နတ်တော်',
              'ပြာသို',
              'တပို့တွဲ',
              'တပေါင်း',
              'နှောင်း တန်ခူး',
              'နှောင်း ကဆုန်',
            ];
            String myanmarMonth = (mm >= 0 && mm < myanmarMonths.length)
                ? myanmarMonths[mm]
                : 'Unknown';
            String monthType = _getMyanmarMonthType(md);
            String myanmarMonthDisplay = '$myanmarMonth $monthType';
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Myanmar Date: ${_toMyanmarNumber(my)} $myanmarMonthDisplay ${_toMyanmarNumber(md)} ရက်',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  static String _toMyanmarNumber(int number) {
    const myanmarDigits = ['၀', '၁', '၂', '၃', '၄', '၅', '၆', '၇', '၈', '၉'];
    return number.toString().split('').map((d) => myanmarDigits[int.parse(d)]).join();
  }

  static String _gregorianMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (month < 1 || month > 12) return '';
    return monthNames[month - 1];
  }

  static String _getMyanmarMonthType(int md) {
    if (md < 15) return "လဆန်း";
    if (md == 15) return "လပြည့်";
    return "လပြည့်ကျော်";
  }

  static double modernDateToJulianDay(int year, int month, int day) {
    if (month < 3) {
      year = year - 1;
      month = month + 12;
    }
    double julianDay = (365.25 * year).toInt() + (30.59 * (month - 2)).toInt() + day + 1721086.5;
    if (year < 0) {
      julianDay = julianDay - 1;
      if ((year % 4) == 0 && 3 <= month) {
        julianDay = julianDay + 1;
      }
    }
    if (2299160 < julianDay) {
      julianDay = julianDay + (year / 400).toInt() - (year / 100).toInt() + 2;
    }
    return julianDay;
  }

  /// Myanmar calendar calculation logic (j2m)
  /// Returns: [myt, my, mm, md]
  static List<int> j2m(double jd) {
    int jdn = jd.round();
    double SY = 1577917828.0 / 4320000.0;
    double MO = 1954168.050623;
    int my = ((jdn - 0.5 - MO) / SY).floor();
    var mytTg1FmWerr = cal_my(my);
    int myt = mytTg1FmWerr[0];
    int tg1 = mytTg1FmWerr[1];
    // int fm = mytTg1FmWerr[2]; // Full moon day (unused in this calculation)
    // int werr = mytTg1FmWerr[3]; // Watat error (unused in this calculation)

    int dd = jdn - tg1 + 1;
    int b = (myt / 2).floor();
    int c = (1 / (myt + 1)).floor();
    int myl = 354 + (1 - c) * 30 + b;
    int mmt = ((dd - 1) / myl).floor();
    dd -= mmt * myl;
    int a = ((dd + 423) / 512).floor();
    int mm = ((dd - b * a + c * a * 30 + 29.26) / 29.544).floor();
    int e = ((mm + 12) / 16).floor();
    int f = ((mm + 11) / 16).floor();
    int md = dd - (29.544 * mm - 29.26).floor() - b * e + c * f * 30;
    mm += f * 3 - e * 4 + 12 * mmt;
    return [myt, my, mm, md];
  }

  /// Helper: Check Myanmar Year
  /// Returns: [myt, tg1, fm, werr]
  static List<int> cal_my(int my) {
    int yd = 0, nd = 0, y1watat = 0, y1fm = 0, y2watat = 0, y2fm = 0, werr = 0;
    var y2 = cal_watat(my);
    y2watat = y2[0];
    y2fm = y2[1];
    int myt = y2watat;
    do {
      yd++;
      var y1 = cal_watat(my - yd);
      y1watat = y1[0];
      y1fm = y1[1];
    } while (y1watat == 0 && yd < 3);
    int fm;
    if (myt != 0) {
      nd = (y2fm - y1fm) % 354;
      myt = (nd / 31).floor() + 1;
      fm = y2fm;
      if (nd != 30 && nd != 31) werr = 1;
    } else {
      fm = y1fm + 354 * yd;
    }
    int tg1 = y1fm + 354 * yd - 102;
    return [myt, tg1, fm, werr];
  }

  /// Helper: Check watat (intercalary month)
  /// Returns: [watat, fm]
  static List<int> cal_watat(int my) {
    double SY = 1577917828.0 / 4320000.0;
    double LM = 1577917828.0 / 53433336.0;
    double MO = 1954168.050623;
    double EI = 3, WO = -0.5, NM = 8;
    double TA = (SY / 12 - LM) * (12 - NM);
    double ed = (SY * (my + 3739)) % LM;
    if (ed < TA) ed += LM;
    int fm = (SY * my + MO - ed + 4.5 * LM + WO).round();
    double TW = 0;
    int watat = 0;
    if (EI >= 2) {
      TW = LM - (SY / 12 - LM) * NM;
      if (ed >= TW) watat = 1;
    } else {
      watat = (my * 7 + 2) % 19;
      if (watat < 0) watat += 19;
      watat = (watat / 12).floor();
    }
    return [watat, fm];
  }

  /// Convert Julian Day Number to Gregorian date
  /// Returns [year, month, day]
  static List<int> jdnToGregorian(double jd) {
    int J = jd.floor() + 32044;
    int g = J ~/ 146097;
    int dg = J % 146097;
    int c = ((dg ~/ 36524) + 1) * 3 ~/ 4;
    int dc = dg - c * 36524;
    int b = dc ~/ 1461;
    int db = dc % 1461;
    int a = ((db ~/ 365) + 1) * 3 ~/ 4;
    int da = db - a * 365;
    int y = g * 400 + c * 100 + b * 4 + a;
    int m = (da * 5 + 308) ~/ 153 - 2;
    int d = da - ((m + 4) * 153 ~/ 5) + 122;
    int year = y - 4800 + ((m + 2) ~/ 12);
    int month = (m + 2) % 12 + 1;
    int day = d + 1;
    return [year, month, day];
  }

  /// Convert Myanmar date to Julian Day Number
  static int myanmarToJdn(int myYear, int myMonth, int myDay) {
    // double SY = 1577917828.0 / 4320000.0; // Solar year (unused)
    // double MO = 1954168.050623; // Mean lunar month (unused)
    var mytTg1FmWerr = cal_my(myYear);
    int myt = mytTg1FmWerr[0];
    int tg1 = mytTg1FmWerr[1];
    int b = (myt / 2).floor();
    int c = (1 / (myt + 1)).floor();
    int mm = myMonth;
    int mmt = 0;
    if (mm >= 13) {
      mmt = 1;
      mm -= 12;
    }
    if (mm == 0) {
      mm = 4;
      mmt = 0;
    }
    int e = ((mm + 12) / 16).floor();
    int f = ((mm + 11) / 16).floor();
    int dd = myDay;
    mm -= f * 3 - e * 4;
    dd += (29.544 * mm - 29.26).floor() + b * e - c * f * 30;
    dd += mmt * (354 + (1 - c) * 30 + b);

    return tg1 + dd - 1;
  }
}
