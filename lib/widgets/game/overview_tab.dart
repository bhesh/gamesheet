import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/model/game.dart';
import 'package:gamesheet/model/score.dart';
import 'package:gamesheet/model/summary.dart';
import 'package:gamesheet/widgets/game/winner_list.dart';
import 'package:provider/provider.dart';
import './summary.dart';

class OverviewTab extends StatelessWidget {
  final Game game;
  final int numPlayers;
  final List<String> roundLabels;

  const OverviewTab({
    super.key,
    required this.game,
    required this.numPlayers,
    required this.roundLabels,
  });

  @override
  Widget build(BuildContext context) {
    // Get data
    final gameModel = Provider.of<GameModel>(context);
    assert(gameModel.players != null);
    final players = gameModel.players!;

    // Build list
    return SliverList.list(
      children: <Widget>[
        Consumer<ScoreModel>(
          builder: (context, scoreModel, _) {
            return FutureProvider<GameSummary?>.value(
              initialData: null,
              value: calculateSummary(game, scoreModel.scores),
              child: Summary(
                game: game,
                players: players,
                scores: scoreModel.scores,
                winners: WinnerList(
                  winners: scoreModel.winners,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
