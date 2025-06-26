/// Utility functions for Myanmar calendar conversions
///
/// This class provides convenient static methods for converting between
/// Myanmar and Gregorian dates without requiring widget instantiation.
class MyanmarCalendarUtils {
  /// Convert Myanmar date to Gregorian date
  /// Returns formatted date string "YYYY-MM-DD"
  static String myanmarToGregorian(int myYear, int myMonth, int myDay) {
    // Use the existing implementation from the widget
    return _MyanmarCalendarWidgetState.myanmarToGregorian(myYear, myMonth, myDay);
  }

  /// Convert Myanmar date to Gregorian with readable month names
  /// Returns formatted date string "Day Month Year"
  static String myanmarToGregorianFull(int myYear, int myMonth, int myDay) {
    // Use the existing implementation from the widget
    return _MyanmarCalendarWidgetState.myanmarToGregorianFull(myYear, myMonth, myDay);
  }
}
