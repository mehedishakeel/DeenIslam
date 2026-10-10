/// Utility for converting and formatting Bengali numerals and timestamps
class BengaliNumerals {
  static const Map<String, String> _enToBn = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  static const Map<String, String> _bnToEn = {
    '০': '0',
    '১': '1',
    '২': '2',
    '৩': '3',
    '৪': '4',
    '৫': '5',
    '৬': '6',
    '৭': '7',
    '৮': '8',
    '৯': '9',
  };

  /// Convert any number or string with English digits to Bengali numerals
  static String toBengali(dynamic input) {
    if (input == null) return '';
    final str = input.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      buffer.write(_enToBn[char] ?? char);
    }
    return buffer.toString();
  }

  /// Alias for toBengali
  static String convert(dynamic input) => toBengali(input);

  /// Convert string with Bengali numerals back to English digits
  static String toEnglish(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_bnToEn[char] ?? char);
    }
    return buffer.toString();
  }

  /// Pad number with zero and convert to Bengali
  static String padZero(int num, [int width = 2]) {
    final padded = num.toString().padLeft(width, '0');
    return toBengali(padded);
  }

  /// Format duration as hh:mm:ss in Bengali
  static String formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final mins = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);
    return '${padZero(hours)}:${padZero(mins)}:${padZero(secs)}';
  }
}
