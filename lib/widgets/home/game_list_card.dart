import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/widgets/card.dart';

class GameListCard extends StatelessWidget {
  static final DateFormat dateFormatter = DateFormat.yMMMd().add_jm();

  final Game game;
  final void Function(Game game)? onSelected;

  const GameListCard({
    super.key,
    required this.game,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      padding: EdgeInsets.all(8),
      onTap: () => onSelected == null ? {} : onSelected!(game),
      child: Container(
        height: 60,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(game.type.icon, size: 40.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    game.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    game.type.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75)),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                dateFormatter.format(game.created.toLocal()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.75)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
