import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

abstract final class AppLoading {
  AppLoading._();

  static Widget _defaultSpinner = const SpinKitCircle(
    color: Colors.white,
    size: 40,
  );

  static void configure({
    Widget? defaultSpinner,
  }) {
    if (defaultSpinner != null) {
      _defaultSpinner = defaultSpinner;
    }
  }

  static void show() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black26,
          alignment: Alignment.center,
          child: _defaultSpinner,
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isSnackbarOpen) {
      Get.back(closeOverlays: true);
    }

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}