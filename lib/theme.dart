import 'package:flutter/material.dart';

class Theme {
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFF658AD5),
      100: Color(0xFF658AD5),
      200: Color(0xFF658AD5),
      300: Color(0xFF658AD5),
      400: Color(0xFF658AD5),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF658AD5),
      700: Color(0xFF658AD5),
      800: Color(0xFF658AD5),
      900: Color(0xFF658AD5),
    },
  );
  static const int _bluePrimaryValue = 0xFF658AD5;
}
