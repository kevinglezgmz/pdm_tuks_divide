import 'package:flutter/services.dart';

class DecimalTextInputFormatter implements TextInputFormatter {
  late RegExp _exp;

  DecimalTextInputFormatter({
    int? decimalRange,
  }) : assert(decimalRange == null || decimalRange >= 0,
            'DecimalTextInputFormatter declaretion error') {
    String dp = (decimalRange != null && decimalRange > 0)
        ? "([.][0-9]{0,$decimalRange}){0,1}"
        : "";
    String num = "[0-9]*$dp";
    _exp = RegExp("^($num){0,1}\$");
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
