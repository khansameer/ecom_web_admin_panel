import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) return newValue;

    // Match valid price with up to 2 decimals
    final regExp = RegExp(r'^[0-9]+(\.[0-9]{0,2})?$');

    if (regExp.hasMatch(text)) {
      return newValue; // valid -> allow
    }

    return oldValue; // invalid -> keep old value (instead of clearing all)
  }
}
