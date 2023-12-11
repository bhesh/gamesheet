import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/widgets/newgame/player_input.dart';

class PlayerPopup extends StatelessWidget {
  final List<(String, Palette)> players;
  final int selected;
  final void Function(int)? onSelected;

  const PlayerPopup({
    required this.playerControllers,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    assert(selected < playerControllers.length);
    return _PlayerPopupItem(
      item: playerControllers[selected],
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
              String? name = playerControllers[index].name;
              return _PlayerPopupItem(
                item: Player.values[index],
                onSelected: () {
                  if (onSelected != null) onSelected!(Player.values[index]);
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
    Size size = MediaQuery.of(context).size;
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
        width: size.width * 0.8,
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
