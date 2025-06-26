/// Name calculation functions for Hindu calendar
/// 
/// This file contains functions to calculate names for various
/// Hindu calendar elements like months, tithis, nakshatras, etc.

/// Gets the name of the month
String getMonthName(int month) {
  const List<String> monthNames = [
    'Caitra', 'Vaisakha', 'Jyaistha', 'Asadha', 'Sravana', 'Bhadrapada',
    'Asvina', 'Kartika', 'Margasirsa', 'Pausa', 'Magha', 'Phalguna'
  ];
  
  if (month >= 1 && month <= 12) {
    return monthNames[month - 1];
  }
  return 'Unknown';
}

/// Gets the name of the tithi (lunar day)
String getTithiName(int tithi) {
  const List<String> tithiNames = [
    'Pratipada', 'Dvitiya', 'Tritiya', 'Caturthi', 'Panchami',
    'Sasthi', 'Saptami', 'Astami', 'Navami', 'Dasami',
    'Ekadasi', 'Dvadasi', 'Trayodasi', 'Caturdasi', 'Purnima'
  ];
  
  if (tithi >= 1 && tithi <= 15) {
    return tithiNames[tithi - 1];
  }
  return 'Unknown';
}

/// Gets the name of the nakshatra (lunar mansion)
String getNakshatraName(int nakshatra) {
  const List<String> nakshatraNames = [
    'Asvini', 'Bharani', 'Krittika', 'Rohini', 'Mrigasira', 'Ardra',
    'Punarvasu', 'Pushya', 'Aslesha', 'Magha', 'Purva Phalguni', 'Uttara Phalguni',
    'Hasta', 'Chitra', 'Svati', 'Visakha', 'Anuradha', 'Jyestha',
    'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha',
    'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'
  ];
  
  if (nakshatra >= 1 && nakshatra <= 27) {
    return nakshatraNames[nakshatra - 1];
  }
  return 'Unknown';
}

/// Gets the name of the yoga
String getYogaName(int yoga) {
  const List<String> yogaNames = [
    'Vishkumbha', 'Priti', 'Ayushman', 'Saubhagya', 'Sobhana', 'Atiganda',
    'Sukarman', 'Dhriti', 'Soola', 'Ganda', 'Vriddhi', 'Dhruva',
    'Vyaghata', 'Harshana', 'Vajra', 'Siddhi', 'Vyatipata', 'Variyan',
    'Parigha', 'Siva', 'Siddha', 'Sadhya', 'Subha', 'Sukla',
    'Brahma', 'Indra', 'Vaidhriti'
  ];
  
  if (yoga >= 1 && yoga <= 27) {
    return yogaNames[yoga - 1];
  }
  return 'Unknown';
}

/// Gets the name of the karana
String getKaranaName(int karana) {
  const List<String> karanaNames = [
    'Bava', 'Balava', 'Kaulava', 'Taitila', 'Gara', 'Vanija',
    'Visti', 'Sakuni', 'Chatushpada', 'Naga', 'Kimstughna'
  ];
  
  if (karana >= 1 && karana <= 11) {
    return karanaNames[karana - 1];
  }
  return 'Unknown';
}

/// Gets the name of the weekday
String getWeekdayName(int weekday) {
  const List<String> weekdayNames = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];
  
  if (weekday >= 0 && weekday <= 6) {
    return weekdayNames[weekday];
  }
  return 'Unknown';
}

/// Gets the name of the paksha (lunar fortnight)
String getPakshaName(bool isShukla) {
  return isShukla ? 'Shukla' : 'Krishna';
}

/// Gets the name of the ritu (season)
String getRituName(int month) {
  const List<String> rituNames = [
    'Vasanta', 'Vasanta', 'Grishma', 'Grishma', 'Varsha', 'Varsha',
    'Sharad', 'Sharad', 'Shishira', 'Shishira', 'Hemanta', 'Hemanta'
  ];
  
  if (month >= 1 && month <= 12) {
    return rituNames[month - 1];
  }
  return 'Unknown';
}
