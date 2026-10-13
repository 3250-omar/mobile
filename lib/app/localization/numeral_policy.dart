/// Pure numeral policy utilities conforming to Constitution Principle VIII and FR-009/FR-011.
class NumeralPolicy {
  const NumeralPolicy._();

  static const Map<String, String> _arabicIndicToWesternMap = <String, String>{
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  /// Normalizes user input containing Eastern Arabic-Indic digits to standard Western digits.
  ///
  /// Leaves literal punctuation, alphabetic codes, and symbols intact.
  static String normalizeInputDigits(String input) {
    var output = input;
    _arabicIndicToWesternMap.forEach((arabicDigit, westernDigit) {
      output = output.replaceAll(arabicDigit, westernDigit);
    });
    return output;
  }

  /// Formats a generated integer with Western digits.
  static String formatInteger(int value) => value.toString();

  /// Formats a generated fixed-precision quantity or amount with Western digits.
  static String formatDecimal(double value, {int fractionDigits = 2}) =>
      value.toStringAsFixed(fractionDigits);

  /// Checks if an input string consists entirely of valid digits (Western or Arabic-Indic).
  static bool isValidNumericString(String input) {
    final normalized = normalizeInputDigits(input.trim());
    return RegExp(r'^-?[0-9]+(\.[0-9]+)?$').hasMatch(normalized);
  }
}
