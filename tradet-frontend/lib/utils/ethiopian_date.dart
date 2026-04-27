/// Ethiopian (Ge'ez) calendar converter.
///
/// Converts Gregorian dates to Ethiopian calendar for display when the app
/// locale is Amharic, Tigrinya, Somali, or Guragigna.
class EthiopianDate {
  // Month names per language
  static const _amharic = [
    'መስከረም', 'ጥቅምት', 'ህዳር', 'ታህሳስ', 'ጥር', 'የካቲት',
    'መጋቢት', 'ሚያዝያ', 'ግንቦት', 'ሰኔ', 'ሐምሌ', 'ነሐሴ', 'ጳጉሜ',
  ];
  static const _tigrinya = [
    'መስከረም', 'ጥቅምቲ', 'ሕዳር', 'ታሕሳስ', 'ጥሪ', 'ለካቲት',
    'መጋቢት', 'ሚያዝያ', 'ግንቦት', 'ሰነ', 'ሓምለ', 'ነሓሰ', 'ጳጉሜ',
  ];
  // Somali and Guragigna use transliterated ET month names
  static const _somali = [
    'Meskerem', 'Tikimt', 'Hidar', 'Tahsas', 'Tir', 'Yekatit',
    'Megabit', 'Miyazya', 'Ginbot', 'Sene', 'Hamle', 'Nehasie', 'Pagume',
  ];

  /// Returns true if [langCode] uses the Ethiopian calendar.
  static bool usesEthiopianCalendar(String langCode) =>
      ['am', 'ti', 'so', 'gur'].contains(langCode);

  /// Formats [date] in the appropriate calendar for [langCode].
  /// Ethiopian calendar for am/ti/so/gur; Gregorian for en/om.
  static String formatDate(DateTime date, String langCode) {
    if (!usesEthiopianCalendar(langCode)) {
      return _formatGregorian(date);
    }
    final eth = _fromGregorian(date);
    final month = _monthName(eth.month, langCode);
    return '${eth.day} $month ${eth.year}';
  }

  /// Formats a short date (e.g. for list items).
  static String formatShort(DateTime date, String langCode) {
    if (!usesEthiopianCalendar(langCode)) {
      return '${date.day}/${date.month}/${date.year}';
    }
    final eth = _fromGregorian(date);
    return '${eth.day}/${eth.month}/${eth.year}';
  }

  /// Parses an ISO date string and formats it.
  static String formatIso(String isoString, String langCode) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return formatDate(dt, langCode);
    } catch (_) {
      return isoString;
    }
  }

  /// Parses an ISO date string and formats it short.
  static String formatIsoShort(String isoString, String langCode) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return formatShort(dt, langCode);
    } catch (_) {
      return isoString;
    }
  }

  // ─── Internal ────────────────────────────────────────────────────────────

  static String _formatGregorian(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String _monthName(int m, String langCode) {
    final idx = (m - 1).clamp(0, 12);
    switch (langCode) {
      case 'ti': return _tigrinya[idx];
      case 'so': return _somali[idx];
      default: return _amharic[idx]; // am, gur
    }
  }

  // Gregorian → Julian Day Number
  static int _toJDN(int y, int m, int d) {
    final a = (14 - m) ~/ 12;
    final yr = y + 4800 - a;
    final mo = m + 12 * a - 3;
    return d + (153 * mo + 2) ~/ 5 + 365 * yr + yr ~/ 4 - yr ~/ 100 + yr ~/ 400 - 32045;
  }

  // JDN → Ethiopian date (epoch: Meskerem 1, 1 EC = JDN 1724221)
  static ({int year, int month, int day}) _jdnToEthiopian(int jdn) {
    const epoch = 1724221;
    final d = jdn - epoch;
    final cycle = d ~/ 1461;
    final dInCycle = d % 1461;

    int yearInCycle;
    int dayInYear;
    if (dInCycle < 1095) {
      yearInCycle = dInCycle ~/ 365;
      dayInYear = dInCycle % 365;
    } else {
      yearInCycle = 3;
      dayInYear = dInCycle - 1095;
    }

    final year = cycle * 4 + yearInCycle + 1;
    final month = dayInYear ~/ 30 + 1;
    final day = dayInYear % 30 + 1;
    return (year: year, month: month, day: day);
  }

  static ({int year, int month, int day}) _fromGregorian(DateTime date) =>
      _jdnToEthiopian(_toJDN(date.year, date.month, date.day));
}
