import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract final class AppBottomSheet {
  /// Shows a GetX bottom sheet with customizable children
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

  /// Shows a scrollable bottom sheet with action buttons
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