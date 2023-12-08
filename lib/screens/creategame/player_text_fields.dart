import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:material_symbols_icons/symbols.dart';
import './player_controller.dart';
import './player_input.dart';

class PlayerTextFields extends StatelessWidget {
  final List<PlayerController> controllers;
  final int maxNumPlayers;
  final int maxNameLength;
  final String? hintText;
  final String? errorText;
  final void Function()? onAdd;
  final void Function(int, Palette)? onColorChange;
  final void Function(int)? onDelete;

  const PlayerTextFields({
    super.key,
    required this.controllers,
    this.maxNumPlayers = 16,
    this.maxNameLength = 40,
    this.hintText,
    this.errorText,
    this.onAdd,
    this.onColorChange,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    for (int i = 0; i < controllers.length; ++i) {
      children.add(Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: PlayerInput(
          controller: controllers[i],
          maxNameLength: maxNameLength,
          hintText: hintText,
          errorText: errorText,
          onColorChange: (color) =>
              onColorChange == null ? {} : onColorChange!(i, color),
          onDelete: () => onDelete == null ? {} : onDelete!(i),
        ),
      ));
    }
    if (children.isEmpty) {
      children.add(Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Center(
          child: Text(
            errorText ?? 'Add players',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: errorText == null
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                      : Theme.of(context).colorScheme.error.withOpacity(0.7),
                ),
          ),
        ),
      ));
    }
    children.add(IconButton(
      icon: const Icon(Symbols.person_add),
      color: Theme.of(context).colorScheme.primary,
      tooltip: 'Add Player Field',
      onPressed: controllers.length >= maxNumPlayers ? null : onAdd,
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
