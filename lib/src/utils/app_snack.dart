import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract final class AppSnack {
  AppSnack._();

  static const SnackPosition _defaultPosition = SnackPosition.TOP;
  static const SnackStyle _snackStyle = SnackStyle.FLOATING;
  static const Color _successColor = Color(0xFF27ae60);
  static const Color _errorColor = Color(0xFFc0392b);

  static void success(
      String message) {
    _showSnack(
      message: message,
      backgroundColor: _successColor,
    );
  }

  static void error(
      String message) {
    _showSnack(
      message: message,
      backgroundColor: _errorColor,
    );
  }

  static void _showSnack({
    required String message,
    required Color backgroundColor,
  }) {
    if (Get.isSnackbarOpen) Get.back();

    Get.rawSnackbar(
      message: message,
      backgroundColor: backgroundColor,
      snackStyle: _snackStyle,
      snackPosition: _defaultPosition,
      isDismissible: true,
    );
  }
}