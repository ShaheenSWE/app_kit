import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.width = 250,
    this.labelText = 'بحث',
    this.hintText,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onClear;
  final double? width;
  final String labelText;
  final String? hintText;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  late VoidCallback _listener;
  bool _showClose = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }
    _showClose = _controller.text.trim().isNotEmpty;
    _listener = () {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _showClose && mounted) {
        setState(() {
          _showClose = hasText;
        });
      }
    };
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: _controller,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _showClose = true;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        } else {
          setState(() {
            _showClose = false;
          });
          if (widget.onClear != null) {
            widget.onClear!();
          }
        }
      },
      decoration: InputDecoration(
        label: Text(
          widget.labelText,
          style: const TextStyle(color: Colors.black45),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          color: Colors.black38,
        ),
        prefixIcon: const HugeIcon(
          icon: HugeIcons.strokeRoundedSearch01,
          size: 20,
        ).paddingOnly(right: 12, left: 2),
        suffixIcon: !_showClose
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  _controller.clear();
                  setState(() {
                    _showClose = false;
                  });
                  FocusScope.of(context).unfocus();
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                },
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                iconSize: 16,
              ),
      ),
    );

    if (widget.width == null) {
      return field;
    }

    return SizedBox(width: widget.width, child: field);
  }
}
