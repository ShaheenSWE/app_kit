import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class for displaying consistent bottom sheets throughout the app.
///
/// Provides static methods for showing different types of bottom sheets:
/// - [show]: Basic bottom sheet with customizable content
/// - [showActions]: Bottom sheet with scrollable content and action buttons
///
/// Both methods use GetX for sheet management and provide consistent styling.
abstract final class AppBottomSheet {
  // Static utility class - no instance members needed
  // All members are static and documented below

  /// Displays a customizable bottom sheet with optional title and content.
  ///
  /// {@template app_bottom_sheet_parameters}
  /// Parameters:
  /// - `title` : Optional header text (defaults to null)
  /// - `children` : Required content widgets
  /// - `isScrollControlled` : Expands to full height when true (default: true)
  /// - `enableDrag` : Allows swipe dismissal when true (default: true)
  /// - `isDismissible` : Allows tap outside dismissal when true (default: true)
  /// - `padding` : Content padding (default: EdgeInsets.all(16))
  /// - `backgroundColor` : Sheet background (default: Colors.white)
  /// - `topBorderRadius` : Top corner radius (default: 16.0)
  /// {@endtemplate}
  ///
  /// {@template app_bottom_sheet_features}
  /// Features:
  /// - Consistent drag handle indicator
  /// - Themed text styling
  /// - Customizable layout
  /// {@endtemplate}
  ///
  /// Example:
  /// ```dart
  /// await AppBottomSheet.show(
  ///   title: 'Options',
  ///   children: [/* Your content */],
  /// );
  /// ```
  static Future<T?> show<T>({
    String? title,
    required List<Widget> children,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    double topBorderRadius = 16.0,
  }) {
    return Get.bottomSheet<T>(
      Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(topBorderRadius),
          ),
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Get.theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (title != null) ...[
              Text(
                title,
                style: Get.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
            ],
            ...children,
          ],
        ),
      ),
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
    );
  }

  /// Displays a bottom sheet with scrollable content and action buttons.
  ///
  /// {@macro app_bottom_sheet_parameters}
  /// Additional Parameters:
  /// - `actions` : Required list of action buttons
  ///
  /// {@macro app_bottom_sheet_features}
  /// Additional Features:
  /// - Scrollable content area
  /// - Fixed action buttons at bottom
  ///
  /// Example:
  /// ```dart
  /// await AppBottomSheet.showActions(
  ///   title: 'Confirm',
  ///   children: [/* Content */],
  ///   actions: [
  ///     TextButton(/*...*/),
  ///     ElevatedButton(/*...*/),
  ///   ],
  /// );
  /// ```
  static Future<T?> showActions<T>({
    String? title,
    required List<Widget> children,
    required List<Widget> actions,
    bool isScrollControlled = true,
  }) {
    return show<T>(
      title: title,
      isScrollControlled: isScrollControlled,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ],
    );
  }
}