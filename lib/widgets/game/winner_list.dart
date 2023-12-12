import 'package:flutter/material.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/models/game.dart';
import 'package:provider/provider.dart';

class WinnerList extends StatelessWidget {
  final List<int>? winners;
  final Color? textColor;
  final bool border;

  const WinnerList({
    super.key,
    this.winners,
    this.textColor,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameModel>(context);
    List<Widget> children = [Spacer()];
    if (gameProvider.players == null || winners == null || winners!.isEmpty)
      children.add(
        Text('No winners',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: textColor)),
      );
    else {
      winners!.take(5).forEach((index) {
        assert(index < gameProvider.players!.length);
        Player player = gameProvider.players![index];
        var avatar = GamesheetAvatar(
          name: player.name,
          color: player.color,
        );
        children.add(Padding(
            padding: const EdgeInsets.all(5),
            child: border
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 21,
                    child: avatar,
                  )
                : avatar));
      });
      if (winners!.length > 5) {
        children.add(Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '...',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: textColor),
          ),
        ));
      }
    }
    children.add(Spacer());
    return Row(children: children);
  }
}
