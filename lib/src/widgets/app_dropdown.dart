import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../utils/app_kit_colors.dart';

class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    required this.label,
    required this.icon,
    super.key,
    this.items,
    this.asyncItems,
    this.selectedItem,
    this.onChanged,
    this.itemAsString,
    this.validator,
    this.searchThreshold = 6,
    this.enableCache = true,
    this.cacheDuration,
    this.onClear,
  });

  final List<T>? items;
  final Future<List<T>> Function(String)? asyncItems;
  final String label;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemAsString;
  final FormFieldValidator<T>? validator;
  final List<List<dynamic>> icon;
  final int searchThreshold;
  final bool enableCache;
  final Duration? cacheDuration;
  final VoidCallback? onClear;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  List<T>? _items;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    if (_items == null && widget.asyncItems != null) {
      unawaited(
        _fetchItems(),
      ); // fire-and-forget; setState inside handles the rebuild
    }
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        _items = widget.items;
      });
    }
  }

  Future<void> _fetchItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await widget.asyncItems!('');
      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => DropdownSearch<T>(
    items: (filter, loadProps) {
      if (_items != null) {
        return _items!;
      }
      if (widget.asyncItems != null) {
        return widget.asyncItems!(filter);
      }
      return [];
    },
    compareFn: (a, b) => a.toString() == b.toString(),
    itemAsString: widget.itemAsString,
    selectedItem: widget.selectedItem,
    onChanged: widget.onChanged,
    validator: widget.validator,
    onBeforePopupOpening: (selectedItem) async {
      FocusManager.instance.primaryFocus?.unfocus();
      if (widget.asyncItems != null) {
        await _fetchItems();
      }
      return mounted;
    },
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        prefixIcon: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : HugeIcon(icon: widget.icon, color: AppKitColors.blue, size: 20),
        label: Text(
          widget.label,
          style: TextStyle(
            color: AppKitColors.black.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
        filled: true,
        fillColor: AppKitColors.blue.withValues(alpha: 0.02),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppKitColors.blue.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppKitColors.blue.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppKitColors.blue, width: 1.5),
        ),
        suffixIcon: widget.onClear != null && widget.selectedItem != null
            ? IconButton(
                onPressed: widget.onClear,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCancel01,
                  size: 18,
                ),
              )
            : null,
      ),
      baseStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppKitColors.black,
      ),
    ),
    popupProps: PopupProps.menu(
      menuProps: const MenuProps(
        popUpAnimationStyle: AnimationStyle(duration: Duration.zero),
      ),
      searchDelay: Duration.zero,
      showSearchBox: (_items?.length ?? 0) > widget.searchThreshold,
      fit: FlexFit.loose,
      emptyBuilder: (context, searchEntry) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppKitColors.blue.withValues(alpha: 0.2),
              size: 40,
            ),
            const SizedBox(height: 8),
            const Text(
              'لا توجد بيانات',
              style: TextStyle(color: AppKitColors.concrete),
            ),
          ],
        ),
      ),
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          hintText: 'بحث سريع...',
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            size: 20,
            color: AppKitColors.blue,
          ),
          filled: true,
          fillColor: AppKitColors.grey2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
      itemBuilder: (context, item, isSelected, isHighlighted) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppKitColors.blue.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppKitColors.grey3.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.itemAsString?.call(item) ?? item.toString(),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected ? AppKitColors.blue : AppKitColors.black,
                ),
              ),
            ),
            if (isSelected)
              const HugeIcon(
                icon: HugeIcons.strokeRoundedTick01,
                color: AppKitColors.blue,
                size: 18,
              ),
          ],
        ),
      ),
    ),
  );
}
