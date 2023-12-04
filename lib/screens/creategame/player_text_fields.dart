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
    return Column(
      children: <Widget>[
        controllers.isNotEmpty
            ? _buildListView(context)
            : Text(
                errorText == null ? 'Add players' : errorText!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: errorText == null
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7)
                          : Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.7),
                    ),
              ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
        IconButton(
          icon: const Icon(Symbols.person_add),
          color: Theme.of(context).colorScheme.primary,
          tooltip: 'Add Player Field',
          onPressed: controllers.length >= maxNumPlayers ? null : onAdd,
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
        return PlayerInput(
          controller: controllers[index],
          maxNameLength: maxNameLength,
          hintText: hintText,
          errorText: errorText,
          onColorChange: (color) =>
              onColorChange == null ? {} : onColorChange!(index, color),
          onDelete: () => onDelete == null ? {} : onDelete!(index),
        );
      },
      separatorBuilder: (context, index) =>
          Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
    );
  }
}
