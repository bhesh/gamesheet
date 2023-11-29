import 'package:flutter/material.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerTextFields extends StatelessWidget {
  final List<TextEditingController> controllers;
  final int maxNumPlayers;
  final int maxNameLength;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final void Function(BuildContext)? onAdd;
  final void Function(BuildContext, int)? onDelete;

  const PlayerTextFields({
    super.key,
    required this.controllers,
    this.maxNumPlayers = 16,
    this.maxNameLength = 30,
    this.labelText,
    this.helperText,
    this.errorText,
    this.onAdd,
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
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: errorText == null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.error,
                    ),
              ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
        TextButton(
          onPressed: onAdd == null || controllers.length >= maxNumPlayers
              ? null
              : () => onAdd!(context),
          child: Icon(Symbols.add_circle_outline),
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
        return TextField(
          controller: controllers[index],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            helperText: helperText,
            errorText: errorText,
            suffixIcon: IconButton(
              icon: Icon(Symbols.delete),
              onPressed: () =>
                  onDelete == null ? {} : onDelete!(context, index),
            ),
          ),
          maxLength: maxNameLength,
        );
      },
      separatorBuilder: (context, index) =>
          Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
    );
  }
}
