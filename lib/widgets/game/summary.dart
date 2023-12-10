import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/games/score.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/model/summary.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:provider/provider.dart';
import './bar_graph.dart';

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
          ),
        ),
      ],
    );
  }
}
