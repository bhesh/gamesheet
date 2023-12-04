import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/widgets/popup_selector.dart';

class GameTypePopup extends StatelessWidget {
  final GameType selected;
  final void Function(GameType)? onSelected;

  const GameTypePopup({
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupSelector(
      initialSelection: Row(
        children: <Widget>[
          Icon(selected.icon),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              selected.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
        ],
      ),
      selectionPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      itemPadding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: GameType.values.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(29),
          ),
          child: Row(
            children: <Widget>[
              Icon(GameType.values[index].icon, size: 48),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  GameType.values[index].label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ),
            ],
          ),
        );
      },
      onSelected: (index) =>
          onSelected == null ? {} : onSelected!(GameType.values[index]),
    );
  }
}
