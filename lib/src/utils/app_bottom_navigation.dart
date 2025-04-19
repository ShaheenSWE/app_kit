import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomNavigation extends StatelessWidget {
  final List<AppBottomNavItem> items;
  final int initialIndex;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final double iconSize;
  final bool showLabels;

  const AppBottomNavigation({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(_BottomNavController(items: items, initialIndex: initialIndex));

    return Scaffold(
      body: Obx(() => items[Get.find<_BottomNavController>().currentIndex.value].page),
      bottomNavigationBar: Obx(() {
        final controller = Get.find<_BottomNavController>();
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: items.map((item) => item.bottomNavItem).toList(),
          selectedItemColor: selectedColor ?? Get.theme.colorScheme.primary,
          unselectedItemColor: unselectedColor ?? Colors.grey,
          backgroundColor: backgroundColor ?? Get.theme.scaffoldBackgroundColor,
          iconSize: iconSize,
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          type: BottomNavigationBarType.fixed,
        );
      }),
    );
  }
}

class _BottomNavController extends GetxController {
  final List<AppBottomNavItem> items;
  final RxInt currentIndex;

  _BottomNavController({
    required this.items,
    int initialIndex = 0,
  }) : currentIndex = initialIndex.obs;

  void changePage(int index) => currentIndex.value = index;
}

class AppBottomNavItem {
  final Widget page;
  final BottomNavigationBarItem bottomNavItem;

  AppBottomNavItem({
    required this.page,
    required String label,
    required IconData icon,
    Widget? activeIcon,
  }) : bottomNavItem = BottomNavigationBarItem(
    label: label,
    icon: Icon(icon),
    activeIcon: activeIcon ?? Icon(icon),
  );
}