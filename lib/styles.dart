import 'package:flutter/material.dart';

class Styles {
  static const _textSizeDefault = 16.0;
  static final Color _textColorDefault = _hexToColor('000000');
  static const String _fontNameDefault = 'Muli';

  static const navBarTitle = TextStyle(
    fontFamily: _fontNameDefault,
  );
  
  static final textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}