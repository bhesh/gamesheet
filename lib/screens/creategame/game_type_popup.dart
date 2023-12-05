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
          Icon(
            selected.icon,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              selected.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.75)),
            ),
          ),
        ],
      ),
      selectionPadding: const EdgeInsets.only(
        top: 12,
        bottom: 11,
        left: 18,
        right: 10,
      ),
      itemPadding: const EdgeInsets.symmetric(vertical: 5),
      itemCount: GameType.values.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 11,
            left: 18,
            right: 10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(29),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                GameType.values[index].icon,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  GameType.values[index].label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.75)),
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
