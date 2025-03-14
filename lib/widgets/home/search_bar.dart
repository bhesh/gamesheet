import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameListSearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final void Function()? onCleared;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final Color? background;
  final EdgeInsetsGeometry padding;
  final int maxLength;

  const GameListSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onCleared,
    this.controller,
    this.focusNode,
    this.cursorColor,
    this.background,
    this.padding = const EdgeInsets.only(left: 20, right: 10),
    this.maxLength = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        padding: padding,
        height: AppBar().preferredSize.height - 10,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: background ??
              Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(29),
        ),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          cursorColor: cursorColor,
          maxLength: maxLength,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                Symbols.close,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onCleared ?? () => {},
            ),
            hintText: hintText,
            border: InputBorder.none,
            counterText: '',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.75)),
          ),
        ),
      ),
    );
  }
}
