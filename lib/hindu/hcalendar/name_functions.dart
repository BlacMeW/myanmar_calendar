/// Name calculation functions for Hindu calendar
///
/// This file contains functions to calculate names for various
/// Hindu calendar elements like months, tithis, nakshatras, etc.

/// Gets the name of the month
String getMonthName(int month) {
  const List<String> monthNames = [
    'Caitra',
    'Vaisakha',
    'Jyaistha',
    'Asadha',
    'Sravana',
    'Bhadrapada',
    'Asvina',
    'Kartika',
    'Margasirsa',
    'Pausa',
    'Magha',
    'Phalguna',
  ];

  if (month >= 1 && month <= 12) {
    return monthNames[month - 1];
  }
  return 'Unknown';
}

/// Gets the name of the tithi (lunar day)
String getTithiName(int tithi) {
  const List<String> tithiNames = [
    'Pratipada',
    'Dvitiya',
    'Tritiya',
    'Caturthi',
    'Panchami',
    'Sasthi',
    'Saptami',
    'Astami',
    'Navami',
    'Dasami',
    'Ekadasi',
    'Dvadasi',
    'Trayodasi',
    'Caturdasi',
    'Purnima',
  ];

  if (tithi >= 1 && tithi <= 15) {
    return tithiNames[tithi - 1];
  }
  return 'Unknown';
}

/// Gets the name of the nakshatra (lunar mansion)
String getNakshatraName(int nakshatra) {
  const List<String> nakshatraNames = [
    'Asvini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigasira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Aslesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Svati',
    'Visakha',
    'Anuradha',
    'Jyestha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  if (nakshatra >= 1 && nakshatra <= 27) {
    return nakshatraNames[nakshatra - 1];
  }
  return 'Unknown';
}

/// Gets the name of the yoga
String getYogaName(int yoga) {
  const List<String> yogaNames = [
    'Vishkumbha',
    'Priti',
    'Ayushman',
    'Saubhagya',
    'Sobhana',
    'Atiganda',
    'Sukarman',
    'Dhriti',
    'Soola',
    'Ganda',
    'Vriddhi',
    'Dhruva',
    'Vyaghata',
    'Harshana',
    'Vajra',
    'Siddhi',
    'Vyatipata',
    'Variyan',
    'Parigha',
    'Siva',
    'Siddha',
    'Sadhya',
    'Subha',
    'Sukla',
    'Brahma',
    'Indra',
    'Vaidhriti',
  ];

  if (yoga >= 1 && yoga <= 27) {
    return yogaNames[yoga - 1];
  }
  return 'Unknown';
}

/// Gets the name of the karana
String getKaranaName(int karana) {
  const List<String> karanaNames = [
    'Bava',
    'Balava',
    'Kaulava',
    'Taitila',
    'Gara',
    'Vanija',
    'Visti',
    'Sakuni',
    'Chatushpada',
    'Naga',
    'Kimstughna',
  ];

  if (karana >= 1 && karana <= 11) {
    return karanaNames[karana - 1];
  }
  return 'Unknown';
}

/// Gets the name of the weekday
String getWeekdayName(int weekday) {
  const List<String> weekdayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
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
    'Vasanta',
    'Vasanta',
    'Grishma',
    'Grishma',
    'Varsha',
    'Varsha',
    'Sharad',
    'Sharad',
    'Shishira',
    'Shishira',
    'Hemanta',
    'Hemanta',
  ];

  if (month >= 1 && month <= 12) {
    return rituNames[month - 1];
  }
  return 'Unknown';
}

/// Gets the name of the day muhurta (1-15)
String getDayMuhurtaName(int muhurta) {
  const List<String> dayMuhurtaNames = [
    'Rudra', // 1st day muhurta (ရုဒြ)
    'Ahi', // 2nd (သပ္ပ)
    'Mitra', // 3rd (မိတြ)
    'Vasu', // 4th (ဝသု in night list, keeping as Vasu for day)
    'Vara', // 5th (ဥဒက in night, keeping generic)
    'Vishwadeva', // 6th (ဝိဿောဒေဝါ)
    'Abhijit', // 7th (အဘိဇိတ်)
    'Brahma', // 8th (ဗြဟ္မာ)
    'Kunda', // 9th (ကုန္ဒြ)
    'Indragni', // 10th (ဣန္ဒာဂ္နိ)
    'Rakshasa', // 11th (ရက္ခသ)
    'Varuna', // 12th (ဝရုဏ)
    'Aryama', // 13th (အယျမာ)
    'Bhaga', // 14th (ဘဂ)
    'Girish', // 15th (reserved empty in original, using Girish)
  ];

  if (muhurta >= 1 && muhurta <= 15) {
    return dayMuhurtaNames[muhurta - 1];
  }
  return 'Unknown';
}

/// Gets the name of the night muhurta (1-15)
String getNightMuhurtaName(int muhurta) {
  const List<String> nightMuhurtaNames = [
    'Shiva', // 1st night muhurta (သိဝ)
    'Ajapada', // 2nd (အဇပါက်)
    'Ativunika', // 3rd (အတိဗုနိယ)
    'Pushya', // 4th (ပုသျှယ)
    'Ashvinikumara', // 5th (အဿိနိကုမာရ)
    'Dharmaraja', // 6th (ဓမ္မရာဇ)
    'Agni', // 7th (အဂ္ဂိ)
    'Brahma', // 8th (ဗြဟ္မာ)
    'Chandrima', // 9th (စန္ဓိမာ)
    'Aditi', // 10th (အဒိတိ)
    'Brihaspati', // 11th (ဗြိဟပ္ပတိ)
    'Vishnu', // 12th (ဗိဿဏိုး)
    'Surya', // 13th (သူရိယ)
    'Twashta', // 14th (တွဋ္ဌာ)
    'Vayu', // 15th (ဝါယု)
  ];

  if (muhurta >= 1 && muhurta <= 15) {
    return nightMuhurtaNames[muhurta - 1];
  }
  return 'Unknown';
}
