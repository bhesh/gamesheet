import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/provider/score.dart';
import 'package:gamesheet/provider/summary.dart';
import 'package:provider/provider.dart';
import './summary.dart';

class OverviewTab extends StatelessWidget {
  final Game game;
  final List<Player> players;

  const OverviewTab({
    super.key,
    required this.game,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: <Widget>[
        Consumer<ScoreProvider>(
          builder: (context, scoreProvider, _) {
            return FutureProvider<GameSummary?>.value(
              initialData: null,
              value: calculateSummary(game, scoreProvider.scores),
              child: Summary(
                game: game,
                players: players,
                scores: scoreProvider.scores,
                winners: scoreProvider.buildWinnerWidget(
                  context,
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
