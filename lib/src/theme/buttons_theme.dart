import 'package:app_kit/src/theme/texts_theme.dart';
import 'package:flutter/material.dart';

import '../utils/app_kit_colors.dart';

class ButtonsTheme {

  ButtonsTheme._();

  static ButtonStyle buttonStyle({bool isOutline = false}) => ButtonStyle(
      textStyle: const WidgetStatePropertyAll(
        TextsTheme.textStyle,
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      maximumSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      backgroundColor: WidgetStateProperty.all(
        isOutline ? Colors.grey.shade100 : AppKitColors.blue,
      ),
      foregroundColor: WidgetStateProperty.all(
        isOutline ? AppKitColors.black : Colors.white,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Colors.black12, width: 0.2),
        ),
      ),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(
        isOutline ? Colors.black38 : Colors.black87,
      ),
      elevation: WidgetStateProperty.all(2),
    );
}
