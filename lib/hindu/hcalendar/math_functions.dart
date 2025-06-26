/// Mathematical utility functions for Hindu calendar calculations
///
/// This file contains basic mathematical functions required for
/// astronomical calculations in the Hindu calendar system.

import 'dart:math' as math;

/// Converts degrees to radians
double toRadians(double degrees) {
  return degrees * math.pi / 180.0;
}

/// Converts radians to degrees
double toDegrees(double radians) {
  return radians * 180.0 / math.pi;
}

/// Normalizes angle to be within 0-360 degrees
double normalizeAngle(double angle) {
  while (angle < 0) {
    angle += 360;
  }
  while (angle >= 360) {
    angle -= 360;
  }
  return angle;
}

/// Returns the truncated integer part of a number
int trunc(double number) {
  return number.truncate();
}

/// Returns the fractional part of a number
double frac(double number) {
  return number - number.truncate();
}

/// Calculates sine in degrees
double sind(double degrees) {
  return math.sin(toRadians(degrees));
}

/// Calculates cosine in degrees
double cosd(double degrees) {
  return math.cos(toRadians(degrees));
}

/// Calculates tangent in degrees
double tand(double degrees) {
  return math.tan(toRadians(degrees));
}

/// Calculates arcsine in degrees
double asind(double value) {
  return toDegrees(math.asin(value));
}

/// Calculates arctangent in degrees
double atand(double value) {
  return toDegrees(math.atan(value));
}

/// Calculates arctangent2 in degrees
double atan2d(double y, double x) {
  return toDegrees(math.atan2(y, x));
}
