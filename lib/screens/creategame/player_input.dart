import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';
import './player_controller.dart';

class PlayerInput extends StatelessWidget {
  final PlayerController controller;
  final int maxNameLength;
  final String? hintText;
  final String? errorText;
  final void Function(Palette)? onColorChange;
  final void Function()? onDelete;

  const PlayerInput({
    required this.controller,
    this.maxNameLength = 40,
    this.hintText,
    this.errorText,
    this.onColorChange,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      //padding: const EdgeInsets.only(left: 15, right: 10),
      controller: controller.textController,
      maxLength: maxNameLength,
      hintText: hintText,
      errorText: errorText,
      icon: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: controller.color.background,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onTap: () => _colorChooser(
          context,
        ),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Symbols.delete),
        color: Theme.of(context).colorScheme.error,
        tooltip: 'Remove Player Field',
        onPressed: onDelete,
      ),
    );
  }

  void _colorChooser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 75,
              childAspectRatio: 1.0,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: Palette.values.length,
            itemBuilder: (context, colorIndex) {
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Palette.values[colorIndex].background,
                    borderRadius: BorderRadius.circular(37.5),
                  ),
                ),
                onTap: () {
                  if (onColorChange != null)
                    onColorChange!(Palette.values[colorIndex]);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}
