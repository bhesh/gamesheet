import 'package:flutter/material.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/message.dart';

class GameList extends StatelessWidget {
  final List<Game> games;
  final void Function(BuildContext, int) onTap;
  final void Function(BuildContext, int) onDelete;

  const GameList({
    super.key,
    required this.games,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return games.isNotEmpty
        ? _buildListView(context)
        : ScoreboardMessage('No games');
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: games.length,
      itemBuilder: (context, index) {
        final name = "${games[index].id}";
        return Dismissible(
          key: Key(name),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => onDelete(context, index),
          confirmDismiss: (direction) => _confirmDismiss(context),
          background: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Container(color: Theme.of(context).colorScheme.error),
          ),
          child: GestureDetector(
            onTap: () => onTap(context, index),
            child: ScoreboardCard(
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 8, right: 16),
                      child: Icon(
                        games[index].type.icon,
                        size: 40.0,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        games[index].name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        games[index].type.label,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
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
