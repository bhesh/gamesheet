import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/score.dart';
import 'package:gamesheet/models/summary.dart';
import 'package:gamesheet/widgets/bar_graph.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/game/update_player.dart';
import 'package:provider/provider.dart';

class Summary extends StatelessWidget {
  final Game game;
  final List<Player> players;
  final Map<int, Score> scores;
  final Widget winners;

  const Summary({
    super.key,
    required this.game,
    required this.players,
    required this.scores,
    required this.winners,
  });

  @override
  Widget build(BuildContext context) {
    GameSummary? summary = Provider.of<GameSummary?>(context);
    return Column(
      children: <Widget>[
        GamesheetCard(
          title: 'Winning',
          child: Center(child: winners),
        ),
        GamesheetCard(
          title: 'Total Scores',
          child: BarGraph.total(
            game: game,
            players: players,
            scores: scores,
            minValue: summary?.totalScoreRange.minValue,
            maxValue: summary?.totalScoreRange.maxValue,
            onTap: (player) => updatePlayerScreen(context, game, player),
          ),
        ),
        GamesheetCard(
          title: 'Average Scores',
          child: BarGraph.average(
            game: game,
            players: players,
            scores: scores,
            minValue: summary?.averageScoreRange.minValue,
            maxValue: summary?.averageScoreRange.maxValue,
            onTap: (player) => updatePlayerScreen(context, game, player),
          ),
        ),
      ],
    );
  }
}
