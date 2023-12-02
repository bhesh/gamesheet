import 'package:flutter/material.dart';
import 'package:gamesheet/db/color.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerTextFields extends StatelessWidget {
  final List<PlayerController> controllers;
  final int maxNumPlayers;
  final int maxNameLength;
  final String? hintText;
  final String? errorText;
  final void Function(BuildContext)? onAdd;
  final void Function(BuildContext, int)? onAvatar;
  final void Function(BuildContext, int)? onDelete;

  const PlayerTextFields({
    super.key,
    required this.controllers,
    this.maxNumPlayers = 16,
    this.maxNameLength = 30,
    this.hintText,
    this.errorText,
    this.onAdd,
    this.onAvatar,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        controllers.isNotEmpty
            ? _buildListView(context)
            : Text(
                errorText == null ? 'Add players' : errorText!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: errorText == null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.error,
                    ),
              ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
        IconButton(
          icon: Icon(Symbols.person_add),
          color: Theme.of(context).colorScheme.primary,
          tooltip: 'Add Player Field',
          onPressed: onAdd == null || controllers.length >= maxNumPlayers
              ? null
              : () => onAdd!(context),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: controllers.length > maxNumPlayers
          ? maxNumPlayers
          : controllers.length,
      itemBuilder: (context, index) {
        return RoundedTextField(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          controller: controllers[index].textController,
          icon: GestureDetector(
            child: CircleAvatar(
              backgroundColor: controllers[index].color.background,
              radius: 15,
            ),
            onTap: () => onAvatar == null ? {} : onAvatar!(context, index),
          ),
          hintText: hintText,
          errorText: errorText,
          suffixIcon: IconButton(
            icon: Icon(Symbols.delete),
            color: Theme.of(context).colorScheme.error,
            tooltip: 'Remove Player Field',
            onPressed: () => onDelete == null ? {} : onDelete!(context, index),
          ),
        );
      },
      separatorBuilder: (context, index) =>
          Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
    );
  }
}

class PlayerController {
  final TextEditingController textController;
  GameColor color;

  PlayerController()
      : this.textController = TextEditingController(),
        this.color = GameColor.red;

  PlayerController.withColor(this.color)
      : this.textController = TextEditingController();

  PlayerController.random()
      : this.textController = TextEditingController(),
        this.color = GameColor.random;

  @override
  void dispose() {
    textController.dispose();
  }

  String get text => textController.text;

  void setColor(GameColor newColor) {
    color = newColor;
  }

  void randomColor() {
    color = GameColor.random;
  }
}
