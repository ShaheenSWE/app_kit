import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_ribbon.dart';
import 'app_kit_colors.dart';

class AppDialog {
  AppDialog._();

  static Future<T?> show<T>({
    required List<Widget> children,
    double width = 320,
    double? height,
    bool isBlank = false,
    bool isScrollable = true,
  }) {
    return Get.dialog<T>(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppKitColors.grey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.close, size: 17),
                ),
              ).paddingAll(5),
              isBlank
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (height != null)
                    isScrollable
                        ? Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                      ),
                    )
                        : Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: children,
                      ),
                    )
                  else
                    Flexible(
                      child: isScrollable
                          ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                      )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                    ),
                ],
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppRibbon(),
                  if (height != null)
                    isScrollable
                        ? Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                      ),
                    )
                        : Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: children,
                      ).paddingAll(20),
                    )
                  else
                    Flexible(
                      child: isScrollable
                          ? SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                      )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ).paddingAll(20),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide<T>([T? result]) {
    if (Get.isDialogOpen!) {
      Get.back<T>(result: result);
    }
  }

  static void showImagePreview(String imagePath) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
