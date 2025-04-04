import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/controllers/player_controller.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/dialog.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayersCard extends StatelessWidget {
  final List<PlayerController> controllers;
  final int maxNumPlayers;
  final int maxNameLength;
  final String? errorText;
  final void Function()? onAdd;
  final void Function(int, Palette)? onColorChange;
  final void Function(int)? onDelete;

  const PlayersCard({
    super.key,
    required this.controllers,
    this.maxNumPlayers = 16,
    this.maxNameLength = 40,
    this.errorText,
    this.onAdd,
    this.onColorChange,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      title: 'Players',
      child: _PlayerTextFields(
        controllers: controllers,
        maxNumPlayers: maxNumPlayers,
        maxNameLength: maxNameLength,
        hintText: 'Player Name',
        errorText: errorText,
        onAdd: onAdd,
        onColorChange: onColorChange,
        onDelete: onDelete,
      ),
    );
  }
}

class _PlayerTextFields extends StatelessWidget {
  final List<PlayerController> controllers;
  final int maxNumPlayers;
  final int maxNameLength;
  final String? hintText;
  final String? errorText;
  final void Function()? onAdd;
  final void Function(int, Palette)? onColorChange;
  final void Function(int)? onDelete;

  const _PlayerTextFields({
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
        padding: const EdgeInsets.only(bottom: 16),
        child: _PlayerInput(
          controller: controllers[i],
          maxNameLength: maxNameLength,
          hintText: hintText,
          errorText: errorText,
          onColorChange: (color) =>
              onColorChange == null ? {} : onColorChange!(i, color),
          onDelete: () => onDelete == null ? {} : onDelete!(i),
          onSubmitted: (_) {
            int nextIndex = i + 1;
            if (nextIndex < controllers.length)
              controllers[nextIndex].focusNode.requestFocus();
          },
        ),
      ));
    }
    if (children.isEmpty) {
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 16),
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

class _PlayerInput extends StatelessWidget {
  final PlayerController controller;
  final int maxNameLength;
  final String? hintText;
  final String? errorText;
  final void Function(Palette)? onColorChange;
  final void Function()? onDelete;
  final ValueChanged<String>? onSubmitted;

  const _PlayerInput({
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
      contentPadding: EdgeInsets.only(top: 12),
      icon: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => colorChooserDialog(
          context,
          (color) => onColorChange == null ? null : onColorChange!(color),
        ),
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
}
