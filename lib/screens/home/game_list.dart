import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/provider/game.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/message.dart';
import 'package:provider/provider.dart';

class GameList extends StatelessWidget {
  final void Function(Game game)? onSelected;

  const GameList({
    super.key,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    if (provider.games == null) {
      provider.fetchGames();
      return SpinKitRing(
        color: Theme.of(context).colorScheme.primary,
        size: 50,
      );
    }
    return provider.games!.isNotEmpty
        ? _buildListView(context, provider.games!)
        : GamesheetMessage('No games');
  }

  Widget _buildListView(BuildContext context, List<Game> games) {
    final provider = Provider.of<GameProvider>(context);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: games.length,
      itemBuilder: (context, index) {
        assert(index < games.length);
        assert(games[index].id != null);
        final gameId = games[index].id!;
        return Dismissible(
          key: ValueKey(gameId),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => provider.removeGame(gameId),
          confirmDismiss: (_) => _confirmDismiss(context),
          background: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(color: Theme.of(context).colorScheme.error),
          ),
          child: GestureDetector(
            onTap: () => onSelected != null ? onSelected!(games[index]) : {},
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
                                .withOpacity(0.75)),
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
