import 'dart:math';

import 'package:flutter/services.dart';

class PassTextFormatter extends TextInputFormatter {
  static const _maxChars = 11;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '-', oldValue.text);
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator, String oldValue) {
    value = value.replaceAll(seperator, '');
    var newString = '';
    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if (oldValue.length < _formatValueForComparison(value, '-').length) {
        if (i == 9) {
          newString += seperator;
        }
      } else {
        if ((i == 9) && i != value.length - 1) {
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
      if (i == 9) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
