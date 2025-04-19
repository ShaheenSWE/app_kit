import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract final class AppDialog {
  /// Shows a basic GetX dialog with customizable children
  static Future<T?> show<T>({
    String? title,
    required List<Widget> children,
    bool barrierDismissible = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    double borderRadius = 12.0,
  }) {
    return Get.dialog<T>(
      Dialog(
        backgroundColor: backgroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text(
                  title,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              const Divider(height: 24),
            ],
            Flexible(
              child: SingleChildScrollView(
                padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<bool> confirm({
    String title = 'Confirm',
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmButtonColor,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmButtonColor ?? Get.theme.primaryColor,
            ),
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }
}