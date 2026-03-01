import 'package:flutter/material.dart';
import '../utils/app_kit_colors.dart';

class TextFieldTheme {
  TextFieldTheme._();

  static const InputDecorationTheme theme = InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    alignLabelWithHint: true,
    labelStyle: TextStyle(color: Colors.black45, fontFamily: 'Cairo'),
    floatingLabelStyle: TextStyle(
      color: AppKitColors.blue,
      fontWeight: FontWeight.w800,
      fontFamily: 'Cairo',
    ),
    prefixIconColor: Colors.black45,
    suffixIconColor: Colors.black45,
    prefixIconConstraints: BoxConstraints(),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: Colors.black12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(color: AppKitColors.blue),
    ),
  );
}
