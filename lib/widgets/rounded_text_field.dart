import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final Widget? icon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Color? cursorColor;
  final Color? background;
  final EdgeInsetsGeometry padding;
  final int maxLength;

  const RoundedTextField({
    super.key,
    this.hintText,
    this.errorText,
    this.icon,
    this.suffixIcon,
    this.onChanged,
    this.controller,
    this.cursorColor,
    this.background,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.maxLength = 40,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle? hintStyle = Theme.of(context).inputDecorationTheme.hintStyle;
    return Container(
      padding: padding,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: background != null
            ? background
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: cursorColor,
        maxLength: maxLength,
        decoration: InputDecoration(
          icon: Container(
            padding: EdgeInsets.all(5),
            height: 40,
            width: 40,
            child: icon,
          ),
          suffixIcon: suffixIcon,
          hintText: errorText == null ? hintText : errorText,
          counterText: "",
          border: InputBorder.none,
          hintStyle: errorText == null
              ? hintStyle
              : hintStyle == null
                  ? TextStyle(
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.7))
                  : hintStyle!.copyWith(
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.7),
                    ),
        ),
      ),
    );
  }
}
