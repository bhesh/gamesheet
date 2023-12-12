import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatelessWidget {
  final double width;
  final String labelText;
  final TextEditingController? controller;
  final void Function()? onUnfocus;

  const NumberInput({
    super.key,
    this.width = 70,
    required this.labelText,
    this.controller,
    this.onUnfocus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Focus(
        child: TextField(
          controller: controller,
          maxLength: 4,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 8,
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        onFocusChange: (hasFocus) {
          if (!hasFocus && onUnfocus != null) onUnfocus!();
        },
      ),
    );
  }
}
