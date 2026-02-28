import 'dart:async';
import 'package:app_kit/src/utils/app_kit_colors.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';

class AppSnack {
  AppSnack.success({required String message, bool isDelete = false}) {
    unawaited(
      _show(message: message, type: _SnackType.success, isDelete: isDelete),
    );
  }

  AppSnack.error(String message) {
    unawaited(_show(message: message, type: _SnackType.error));
  }

  AppSnack.warning(String message) {
    unawaited(_show(message: message, type: _SnackType.warning));
  }

  Future<void> _show({
    required String message,
    required _SnackType type,
    bool isDelete = false,
  }) async {
    final Color color = type == _SnackType.success
        ? AppKitColors.green
        : type == _SnackType.error
        ? AppKitColors.red
        : AppKitColors.orange;

    ElegantNotification(
      description: Text(message),
      icon: HugeIcon(
        icon: type == _SnackType.success
            ? HugeIcons.strokeRoundedTick01
            : type == _SnackType.error
            ? HugeIcons.strokeRoundedAlertCircle
            : HugeIcons.strokeRoundedAlert01,
        color: color,
        size: 26,
      ),
      progressIndicatorColor: color,
      height: 50,
      width: 250,
      borderRadius: BorderRadius.circular(0),
      displayCloseButton: false,
      animation: AnimationType.fromLeft,
      position: Alignment.topLeft,
      notificationMargin: 10,
      stackedOptions: StackedOptions(
        key: 'snack',
        type: StackedType.below,
        itemOffset: const Offset(0, 10),
      ),
    ).show(Get.context!);
  }
}

enum _SnackType { success, error, warning }
