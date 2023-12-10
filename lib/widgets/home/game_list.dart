import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/model/game_list.dart';
import 'package:gamesheet/widgets/dialog.dart';
import 'package:gamesheet/widgets/message.dart';
import 'package:provider/provider.dart';
import './game_list_card.dart';

class GameList extends StatelessWidget {
  final void Function(Game game)? onSelected;
  final String? filter;

  const GameList({
    super.key,
    this.onSelected,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameListModel>(context);
    return provider.games == null
        ? SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          )
        : provider.games!.isNotEmpty
            ? _buildListView(context, _filtered(provider.games!))
            : GamesheetMessage('No games');
  }

  List<Game> _filtered(List<Game> gameList) {
    if (filter == null) return gameList;
    return gameList.where(
      (game) {
        return game.name.toLowerCase().contains(filter!.toLowerCase());
      },
    ).toList();
  }

  Widget _buildListView(BuildContext context, List<Game> games) {
    final provider = Provider.of<GameListModel>(context);
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
          confirmDismiss: (_) => confirmDeleteDialog(
            context,
            'Do you wish to delete this game?',
          ),
          background: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(color: Theme.of(context).colorScheme.error),
          ),
          child: GameListCard(game: games[index], onSelected: onSelected),
        );
      },
    );
  }
}
