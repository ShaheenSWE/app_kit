import 'package:app_kit/src/theme/text_field_theme.dart';
import 'package:app_kit/src/theme/texts_theme.dart';
import 'package:app_kit/src/utils/app_kit_colors.dart';
import 'package:flutter/material.dart';

import 'buttons_theme.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: .fromSeed(seedColor: AppKitColors.blue),
    fontFamily: 'Cairo',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonsTheme.buttonStyle(),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonsTheme.buttonStyle(isOutline: true),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextsTheme.textStyle,
      bodyMedium: TextsTheme.textStyle,
      bodySmall: TextsTheme.textStyle,
      displayLarge: TextsTheme.textStyle,
      displayMedium: TextsTheme.textStyle,
      displaySmall: TextsTheme.textStyle,
      headlineLarge: TextsTheme.textStyle,
      headlineMedium: TextsTheme.textStyle,
      headlineSmall: TextsTheme.textStyle,
      labelLarge: TextsTheme.textStyle,
      labelMedium: TextsTheme.textStyle,
      labelSmall: TextsTheme.textStyle,
      titleLarge: TextsTheme.textStyle,
      titleMedium: TextsTheme.textStyle,
      titleSmall: TextsTheme.textStyle,
    ),
    inputDecorationTheme: TextFieldTheme.theme,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    focusColor: Colors.transparent,
    iconTheme: const IconThemeData(color: AppKitColors.black),
    dividerTheme: const DividerThemeData(
      color: Colors.black26,
      thickness: 0.3,
      space: 0,
    ),
    listTileTheme: const ListTileThemeData(
      dense: true,
      contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 10),
      tileColor: Colors.transparent,
      selectedColor: Colors.transparent,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      collapsedIconColor: Colors.black45,
    ),
  );
}
