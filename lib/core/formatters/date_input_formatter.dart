import 'dart:math';

import 'package:flutter/services.dart';

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/', oldValue.text);
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator, String oldValue) {
    value = value.replaceAll(seperator, '');
    var newString = '';
    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if (oldValue.length < _formatValueForComparison(value, '/').length) {
        if ((i == 1 || i == 3)) {
          newString += seperator;
        }
      } else {
        if ((i == 1 || i == 3) && i != value.length - 1) {
          newString += seperator;
        }
      }
    }
    return newString;
  }

  String _formatValueForComparison(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';
    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1 || i == 3)) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
