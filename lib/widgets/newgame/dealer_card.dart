import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/widgets/card.dart';

class DealerCard extends StatelessWidget {
  final List<(String, Palette)> players;
  final int selected;
  final void Function(int)? onSelected;

  const DealerCard({
    super.key,
    required this.players,
    this.selected = 0,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      title: 'First Dealer',
      child: _PlayerPopup(
        players: players,
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}

class _PlayerPopup extends StatelessWidget {
  final List<(String, Palette)> players;
  final int selected;
  final void Function(int)? onSelected;

  const _PlayerPopup({
    required this.players,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    assert(selected < players.length);
    var (name, color) = players[selected];
    return _PlayerPopupItem(
      name: name,
      color: color,
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
            itemCount: players.length,
            itemBuilder: (context, index) {
              var (name, color) = players[index];
              return _PlayerPopupItem(
                name: name,
                color: color,
                onSelected: () {
                  if (onSelected != null) onSelected!(index);
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

class _PlayerPopupItem extends StatelessWidget {
  final String name;
  final Palette color;
  final void Function()? onSelected;

  const _PlayerPopupItem({
    super.key,
    required this.name,
    required this.color,
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
        ),
        decoration: BoxDecoration(
          color: addEmphasis(
            Theme.of(context).brightness == Brightness.light,
            color.background,
            50,
          ),
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.75)),
          ),
        ),
      ),
    );
  }
}
