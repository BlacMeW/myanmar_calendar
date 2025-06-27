# Changelog

## [0.3.1] - 2025-06-28

### Fixed
- Fixed a critical issue in the Hindu calendar widget where lunar month and solar month (masa) were incorrectly showing the same value
- Updated month name translations to match the standard Sanskrit names used in the calculation engine
- Improved translation of "Phalguna" month in Myanmar language version

## [0.3.0] - 2025-06-27

### Added
- Added "နေ့" suffix to all Myanmar weekday translations for proper display
- Optimized compact mode for both Hindu calendar widgets for better space utilization
- Improved scrollable layout for compact mode to display more information in less space

### Fixed
- Fixed weekday translation issue where English names weren't being translated correctly
- Fixed translation of "Friday" to properly show as "သောကြာနေ့" instead of just showing English text

## [0.2.0] - 2025-06-27

### Added
- **Hindu Calendar (Panchanga) Support**: Complete traditional Hindu calendar functionality
- `HinduCalendarWidget` with both compact and full display modes
- Complete Panchanga calculations (Tithi, Vara, Nakshatra, Yoga, Karana)
- Astronomical calculations (Sun and Moon longitudes, Julian day)
- Hindu year, lunar month, and paksha calculations
- Seasonal (Ritu) information and traditional Sanskrit names
- Location-aware calculations (latitude/longitude support)
- Enhanced demo application showing both Myanmar and Hindu calendars in tabbed interface

### Enhanced
- Updated package description to reflect dual calendar support
- Improved documentation with comprehensive usage examples
- Enhanced example application with better organization and tabbed interface
- Added comprehensive Hindu calendar usage examples to README

### Technical Improvements
- Robust calculation engines for both calendar systems
- Proper data mapping between calculation engines and widget displays
- Enhanced visual design with color-coded sections and better typography
- Comprehensive error handling and input validation

## [0.1.0] - 2025-06-27

### Added
- Complete Myanmar calendar functionality with date conversion
- `MyanmarCalendarWidget` with both compact and full display modes
- `MyanmarCalendarConverter` for Gregorian to Myanmar date conversion
- Support for traditional Myanmar calendar calculations including Watat years
- Myanmar day names and month names
- Comprehensive demo application showing all features
- Full API documentation and usage examples
- Widget customization options (font size, display mode)

### Features
- **Calendar Widget**: Beautiful Myanmar calendar display with customizable layouts
- **Date Conversion**: Accurate conversion between Gregorian and Myanmar calendars
- **Watat Year Support**: Proper handling of intercalary years in Myanmar calendar
- **Traditional Names**: Support for Myanmar month and day names
- **Easy Integration**: Simple API for Flutter applications

### Documentation
- Complete README with usage examples
- API reference documentation
- Demo application with comprehensive examples
- Installation and setup instructions

### Technical Details
- Based on traditional Myanmar calendar algorithms
- Support for dates from 1900 to 2100
- Efficient calculation methods
- Flutter-optimized widgets with proper state management

## [0.0.2] - 2025-06-26

### Fixed
- Updated example app implementation
- Improved package structure
- Fixed minor issues with documentation

## [0.0.1] - 2025-06-26

### Added
- Initial release of Myanmar Calendar library for Flutter
- Core Myanmar calendar conversion algorithms
- Date conversion between Gregorian and Myanmar calendars
- `MyanmarDate` class for representing Myanmar dates
- `MyanmarCalendarCore` for low-level calendar calculations
- `MyanmarCalendarConverter` for high-level conversion functions
- Support for watat (intercalary) years
- Myanmar calendar widget (`MyanmarCalendarWidget`) with:
  - Full display mode with conversion capabilities
  - Compact display mode
  - Customizable font sizes
  - Interactive date conversion interface
- Myanmar month names in Myanmar script
- Myanmar day names for days of the week
- Automatic number conversion to Myanmar digits
- Moon phase support (waxing, full moon, waning)
- Calendar month generation with Gregorian equivalents
- Date range conversion utilities
- Myanmar holidays and special days calculation
- Comprehensive test suite
- Example application demonstrating all features
- Detailed documentation and usage examples

### Features
- ✅ Accurate Myanmar calendar calculations based on traditional algorithms
- ✅ Bidirectional date conversion (Gregorian ↔ Myanmar)
- ✅ Beautiful Flutter widgets for calendar display
- ✅ Support for both watat and regular years
- ✅ Myanmar numerals and script support
- ✅ Day of week calculations
- ✅ Full moon, waxing, and waning moon phase detection
- ✅ Holiday and special day identification
- ✅ Comprehensive API for calendar operations
- ✅ Well-documented with examples

### Technical Details
- Based on proven Myanmar calendar algorithms
- Julian Day Number calculations for accurate conversions
- Handles intercalary months (watat years) correctly
- Supports wide range of dates
- Optimized for performance
- Type-safe Dart implementation
- Follows Flutter package development best practices

### Documentation
- Comprehensive README with usage examples
- API documentation for all public classes and methods
- Example application demonstrating library features
- Code comments explaining algorithm details
