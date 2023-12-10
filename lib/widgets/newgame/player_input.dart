import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/widgets/newgame/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerController {
  final TextEditingController textController;
  final FocusNode focusNode;
  Palette color;

  PlayerController()
      : this.textController = TextEditingController(),
        this.focusNode = FocusNode(),
        this.color = Palette.red;

  PlayerController.withColor(this.color)
      : this.textController = TextEditingController(),
        this.focusNode = FocusNode();

  PlayerController.random()
      : this.textController = TextEditingController(),
        this.focusNode = FocusNode(),
        this.color = Palette.random;

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
  }

  String get text => textController.text;

  void randomColor() {
    color = Palette.random;
  }
}

class PlayerInput extends StatelessWidget {
  final PlayerController controller;
  final int maxNameLength;
  final String? hintText;
  final String? errorText;
  final void Function(Palette)? onColorChange;
  final void Function()? onDelete;
  final ValueChanged<String>? onSubmitted;

  const PlayerInput({
    required this.controller,
    this.maxNameLength = 40,
    this.hintText,
    this.errorText,
    this.onColorChange,
    this.onDelete,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      controller: controller.textController,
      focusNode: controller.focusNode,
      maxLength: maxNameLength,
      hintText: hintText,
      errorText: errorText,
      onSubmitted: onSubmitted,
      icon: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => _colorChooser(context),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: controller.color.background,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
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
