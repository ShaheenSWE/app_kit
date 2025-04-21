import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A customizable bottom navigation bar that manages page navigation using GetX.
///
/// This widget provides a complete scaffold with:
/// - Body content that switches between pages
/// - A persistent bottom navigation bar
/// - Built-in state management using GetX
///
/// Example:
/// ```dart
/// AppBottomNavigation(
///   items: [
///     AppBottomNavigationItem(
///       page: HomePage(),
///       label: 'Home',
///       icon: Icons.home,
///     ),
///     AppBottomNavigationItem(
///       page: ProfilePage(),
///       label: 'Profile',
///       icon: Icons.person,
///     ),
///   ],
/// )
/// ```
class AppBottomNavigation extends StatelessWidget {
  /// The list of navigation items to display
  ///
  /// Must contain at least one item
  final List<AppBottomNavigationItem> items;

  /// The initially selected index (defaults to 0)
  final int initialIndex;

  /// Color for the selected item
  ///
  /// Defaults to theme's primary color if not provided
  final Color? selectedColor;

  /// Color for unselected items
  ///
  /// Defaults to Colors.grey if not provided
  final Color? unselectedColor;

  /// Background color of the navigation bar
  ///
  /// Defaults to scaffold background color if not provided
  final Color? backgroundColor;

  /// Size of the navigation icons (defaults to 24.0)
  final double iconSize;

  /// Whether to show labels under icons (defaults to true)
  final bool showLabels;

  /// Creates an application bottom navigation bar
  ///
  /// [items] must not be empty
  AppBottomNavigation({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.showLabels = true,
  }) : assert(items.isNotEmpty, 'Items list cannot be empty');

  @override
  Widget build(final BuildContext context) {
    Get.put(_BottomNavController(items: items, initialIndex: initialIndex));

    return Scaffold(
      body: Obx(() => items[Get.find<_BottomNavController>().currentIndex.value].page),
      bottomNavigationBar: Obx(() {
        final controller = Get.find<_BottomNavController>();
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: items.map((final item) => item.bottomNavItem).toList(),
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

/// Controller for managing bottom navigation state
///
/// This GetX controller handles:
/// - Current selected index state
/// - Page change logic
class _BottomNavController extends GetxController {
  /// List of available navigation items
  final List<AppBottomNavigationItem> items;

  /// Observable current selected index
  final RxInt currentIndex;

  /// Creates a navigation controller
  ///
  /// [items] must not be empty
  /// [initialIndex] defaults to 0
  _BottomNavController({
    required this.items,
    final int initialIndex = 0,
  })  : assert(items.isNotEmpty, 'Items list cannot be empty'),
        assert(initialIndex >= 0 && initialIndex < items.length,
        'Initial index must be valid',),
        currentIndex = initialIndex.obs;

  /// Changes the current page to the specified index
  ///
  /// Throws an assertion error if [index] is out of bounds
  void changePage(final int index) {
    assert(index >= 0 && index < items.length, 'Index out of bounds');
    currentIndex.value = index;
  }
}

/// Represents a single item in the bottom navigation bar
///
/// Combines both:
/// - The page to display when selected
/// - The visual representation in the navigation bar
class AppBottomNavigationItem {
  /// The page widget to display when this item is selected
  final Widget page;

  /// The visual representation in the navigation bar
  final BottomNavigationBarItem bottomNavItem;

  /// Creates a navigation item
  ///
  /// [page] - The content to display when selected
  /// [label] - The text to show below the icon
  /// [icon] - The icon to display
  /// [activeIcon] - Optional different icon when selected
  AppBottomNavigationItem({
    required this.page,
    required final String label,
    required final IconData icon,
    final Widget? activeIcon,
  }) : bottomNavItem = BottomNavigationBarItem(
    label: label,
    icon: Icon(icon),
    activeIcon: activeIcon ?? Icon(icon),
  );
}