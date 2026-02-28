
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../utils/app_kit_colors.dart';

class AppTable<T> extends StatelessWidget {
  const AppTable({
    required this.headers,
    required this.cellWidths,
    required this.stream,
    required this.cellBuilders,
    required this.isExpanded,
    super.key,
    this.onInfo,
    this.onEdit,
    this.onDelete,
    this.emptyMessage = 'لا توجد بيانات',
    this.errorMessage = 'حدث خطأ أثناء تحميل البيانات',
    this.rowPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
  });

  final List<String> headers;
  final List<AppTableCellWidth> cellWidths;
  final Stream<List<T>>? stream;
  final List<Widget Function(T)> cellBuilders;
  final void Function(T)? onInfo;
  final void Function(T)? onEdit;
  final void Function(T)? onDelete;
  final bool isExpanded;
  final String emptyMessage;
  final String errorMessage;
  final EdgeInsetsGeometry rowPadding;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _AppTableHeader<T>(
        headers: headers,
        cellWidths: cellWidths,
        onInfo: onInfo,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      Expanded(
        flex: isExpanded ? 1 : 0,
        child: Stack(
          children: [
            if (!isExpanded)
              const SizedBox()
            else
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                itemBuilder: (context, index) => _AppTableRowEmpty<T>(
                  cellWidths: cellWidths,
                  color: index.isEven ? Colors.white : AppKitColors.grey1,
                  onInfo: onInfo,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  rowPadding: rowPadding,
                ),
              ),

            //stream from drift
            StreamBuilder<List<T>>(
              stream: stream,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (snapshot.hasError) {
                  return const SizedBox();
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const SizedBox();
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  // Use passed physics or default
                  physics: const ClampingScrollPhysics(),
                  // Use passed shrinkWrap or default false
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) => _AppTableRow<T>(
                    cellWidths: cellWidths,
                    cellBuilders: cellBuilders,
                    data: items[index],
                    color: index.isEven ? Colors.white : AppKitColors.grey1,
                    onInfo: onInfo,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    rowPadding: rowPadding,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}

class AppTableCellWidth {
  final int? flex;
  final double? fixed;

  const AppTableCellWidth.flex(this.flex) : fixed = null;
  const AppTableCellWidth.fixed(this.fixed) : flex = null;

  bool get isFlex => flex != null;
  bool get isFixed => fixed != null;
}

class _AppTableRowEmpty<T> extends StatelessWidget {
  const _AppTableRowEmpty({
    required this.cellWidths,
    required this.color,
    required this.rowPadding,
    super.key,
    this.onInfo,
    this.onEdit,
    this.onDelete,
  });

  final List<AppTableCellWidth> cellWidths;
  final Color color;
  final EdgeInsetsGeometry rowPadding;
  final void Function(T)? onInfo;
  final void Function(T)? onEdit;
  final void Function(T)? onDelete;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      border: const Border(
        bottom: BorderSide(color: Colors.black12, width: 0.5),
      ),
    ),
    child: SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: cellWidths
                  .asMap()
                  .entries
                  .map(
                    (entry) =>
                        Expanded(
                              flex: entry.value.isFlex ? entry.value.flex! : 0,
                              child: SizedBox(
                                width: entry.value.isFixed
                                    ? entry.value.fixed!
                                    : double.infinity,
                                child: Padding(
                                  padding: rowPadding,
                                  child: const SizedBox(),
                                ),
                              ),
                            )
                            as Widget,
                  )
                  ._intersperse(Container(width: 0.5, color: Colors.black12))
                  .toList(),
            ),
          ),
          if (onInfo != null || onEdit != null || onDelete != null)
            Container(width: 0.5, color: Colors.black12),
          if (onInfo != null)
            const IconButton(onPressed: null, icon: SizedBox(width: 24)),
          if (onEdit != null)
            const IconButton(onPressed: null, icon: SizedBox(width: 24)),
          if (onDelete != null)
            const IconButton(onPressed: null, icon: SizedBox(width: 24)),
          if (onInfo == null && onEdit == null && onDelete == null)
            const SizedBox(width: 10),
        ],
      ),
    ),
  );
}

extension IntersperseExtension<T> on Iterable<T> {
  List<T> _intersperse(T separator) {
    final result = <T>[];
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return result;
    }

    result.add(iterator.current);
    while (iterator.moveNext()) {
      result
        ..add(separator)
        ..add(iterator.current);
    }
    return result;
  }
}

class _AppTableRow<T> extends StatelessWidget {
  const _AppTableRow({
    required this.cellWidths,
    required this.data,
    required this.cellBuilders,
    required this.color,
    required this.rowPadding,
    super.key,
    this.onInfo,
    this.onEdit,
    this.onDelete,
  });

  final List<AppTableCellWidth> cellWidths;
  final T data;
  final List<Widget Function(T)> cellBuilders;
  final Color color;
  final EdgeInsetsGeometry rowPadding;
  final void Function(T)? onInfo;
  final void Function(T)? onEdit;
  final void Function(T)? onDelete;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      border: const Border(
        bottom: BorderSide(color: Colors.black12, width: 0.5),
      ),
    ),
    child: SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: cellBuilders
                  .asMap()
                  .entries
                  .map(
                    (entry) =>
                        Expanded(
                              flex: cellWidths[entry.key].isFlex
                                  ? cellWidths[entry.key].flex!
                                  : 0,
                              child: SizedBox(
                                width: cellWidths[entry.key].isFixed
                                    ? cellWidths[entry.key].fixed!
                                    : double.infinity,
                                child: Padding(
                                  padding: rowPadding,
                                  child: entry.value(data),
                                ),
                              ),
                            )
                            as Widget,
                  )
                  ._intersperse(Container(width: 0.5, color: Colors.black12))
                  .toList(),
            ),
          ),
          if (onInfo != null || onEdit != null || onDelete != null)
            Container(width: 0.5, color: Colors.black12),
          if (onInfo != null)
            IconButton(
              onPressed: () => onInfo!(data),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRounded0Square,
                color: AppKitColors.black,
                size: 20,
              ),
            ),
          if (onEdit != null)
            IconButton(
              onPressed: () => onEdit!(data),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedBookEdit,
                color: AppKitColors.blue,
                size: 20,
              ),
            ),
          if (onDelete != null)
            IconButton(
              onPressed: () => onDelete!(data),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedColumnDelete,
                color: AppKitColors.red,
                size: 20,
              ),
            ),
          if (onInfo == null && onEdit == null && onDelete == null)
            const SizedBox(width: 10),
        ],
      ),
    ),
  );
}

class _AppTableHeader<T> extends StatelessWidget {
  const _AppTableHeader({
    required this.headers,
    required this.cellWidths,
    super.key,
    this.onInfo,
    this.onEdit,
    this.onDelete,
  });

  final List<String> headers;
  final List<AppTableCellWidth> cellWidths;
  final void Function(T)? onInfo;
  final void Function(T)? onEdit;
  final void Function(T)? onDelete;

  @override
  Widget build(BuildContext context) => Container(
    height: 36,
    decoration: const BoxDecoration(color: AppKitColors.black),
    child: Row(
      children: [
        Expanded(
          child: Row(
            children: headers
                .asMap()
                .entries
                .map<Widget>(
                  (entry) => Expanded(
                    flex: cellWidths[entry.key].isFlex
                        ? cellWidths[entry.key].flex!
                        : 0,
                    child: SizedBox(
                      width: cellWidths[entry.key].isFixed
                          ? cellWidths[entry.key].fixed!
                          : double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
                ._intersperse(Container(width: 0.5, color: Colors.white24))
                .toList(),
          ),
        ),
        if (onInfo != null || onEdit != null || onDelete != null)
          Container(width: 0.5, color: Colors.white24),
        if (onInfo != null)
          const IconButton(onPressed: null, icon: SizedBox(width: 24)),
        if (onEdit != null)
          const IconButton(onPressed: null, icon: SizedBox(width: 24)),
        if (onDelete != null)
          const IconButton(onPressed: null, icon: SizedBox(width: 24)),
        if (onInfo == null && onEdit == null && onDelete == null)
          const SizedBox(width: 10),
      ],
    ),
  );
}
