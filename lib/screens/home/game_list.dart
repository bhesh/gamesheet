import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/message.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Game>? games = context.watch();
    return games == null
        ? SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          )
        : games!.isNotEmpty
            ? _buildListView(context, games!)
            : GamesheetMessage('No games');
  }

  Widget _buildListView(BuildContext context, List<Game> games) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: games.length,
      itemBuilder: (context, index) {
        assert(index < games.length);
        assert(games[index].id != null);
        final id = "${games[index].id}";
        return Dismissible(
          key: Key(id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => GameDatabase.removeGame(gameId),
          confirmDismiss: (_) => _confirmDismiss(context),
          background: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(color: Theme.of(context).colorScheme.error),
          ),
          child: GestureDetector(
            onTap: () => onTap(index),
            child: GamesheetCard(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 8, right: 16),
                      child: Icon(
                        games[index].type.icon,
                        size: 40.0,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        games[index].name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        games[index].type.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDismiss(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Do you wish to delete this game?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.error),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
