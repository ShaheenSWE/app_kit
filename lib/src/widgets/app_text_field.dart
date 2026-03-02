import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.icon,
    super.key,
    this.controller,
    this.onClear,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.onChanged,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.hint,
    this.suffix,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String label;
  final void Function()? onClear;
  final List<List<dynamic>> icon;
  final bool readOnly;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final String? hint;
  final Widget? suffix;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _showClose = false;
  late bool _obscureText;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    focusNode: _focusNode,
    onTapOutside: (event) {
      FocusScope.of(context).unfocus();
    },
    onFieldSubmitted:
        widget.onFieldSubmitted ??
        (value) {
          FocusScope.of(context).unfocus();
        },
    validator: widget.validator,
    textInputAction: widget.textInputAction ?? TextInputAction.done,
    controller: controller,
    readOnly: widget.readOnly,
    onTap: widget.onTap,
    keyboardType: widget.keyboardType,
    inputFormatters: widget.inputFormatters,
    obscureText: _obscureText,
    onChanged: (value) {
      if (value.isNotEmpty) {
        setState(() {
          _showClose = true;
        });
      } else {
        setState(() {
          _showClose = false;
        });
      }
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    },
    decoration: InputDecoration(
      prefixIcon: IconButton(
        onPressed: null,
        icon: HugeIcon(icon: widget.icon, color: Colors.black54, size: 18),
      ),
      label: Text(
        widget.label,
        style: TextStyle(
          color: _isFocused ? Color(0xFF2980b9) : Colors.black45,
        ),
      ),
      hintText: widget.hint,
      suffixIcon:
          widget.suffix ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_showClose)
                const SizedBox()
              else
                IconButton(
                  focusNode: FocusNode(
                    canRequestFocus: false,
                    skipTraversal: true,
                  ),
                  onPressed: () {
                    controller!.clear();
                    setState(() {
                      _showClose = false;
                    });
                    FocusScope.of(context).unfocus();
                    if (widget.onClear != null) {
                      widget.onClear!();
                    }
                  },
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: Colors.black26,
                    size: 16,
                  ),
                ),
              if (widget.obscureText)
                IconButton(
                  focusNode: FocusNode(
                    canRequestFocus: false,
                    skipTraversal: true,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: HugeIcon(
                    icon: _obscureText
                        ? HugeIcons.strokeRoundedViewOff
                        : HugeIcons.strokeRoundedView,
                    color: Colors.black45,
                    size: 18,
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
    ),
  );
}
