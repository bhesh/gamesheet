import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/widgets/card.dart';

class GameTypeCard extends StatelessWidget {
  final GameType selected;
  final void Function(GameType)? onSelected;

  const GameTypeCard({
    super.key,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      title: 'Select game type',
      child: _GameTypePopup(
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}

class _GameTypePopup extends StatelessWidget {
  final GameType selected;
  final void Function(GameType)? onSelected;

  const _GameTypePopup({
    super.key,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _GameTypePopupItem(
      item: selected,
      onSelected: () => _popup(context),
    );
  }

  void _popup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: GameType.values.length,
            itemBuilder: (context, index) {
              return _GameTypePopupItem(
                item: GameType.values[index],
                onSelected: () {
                  if (onSelected != null) onSelected!(GameType.values[index]);
                  Navigator.of(context).pop();
                },
              );
            },
            separatorBuilder: (context, index) =>
                Padding(padding: const EdgeInsets.all(4)),
          ),
        );
      },
    );
  }
}

class _GameTypePopupItem extends StatelessWidget {
  final GameType item;
  final void Function()? onSelected;

  const _GameTypePopupItem({
    super.key,
    required this.item,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(29),
      onTap: onSelected,
      child: Container(
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
              item.icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.75)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
