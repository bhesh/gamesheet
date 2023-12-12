import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/models/game.dart';
import 'package:gamesheet/models/score.dart';
import 'package:gamesheet/models/summary.dart';
import 'package:gamesheet/widgets/game/winner_list.dart';
import 'package:provider/provider.dart';
import './summary.dart';

class OverviewTab extends StatelessWidget {
  final Game game;

  const OverviewTab({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final gameModel = Provider.of<GameModel>(context);
    return SliverList.list(
      children: <Widget>[
        gameModel.players == null || gameModel.scores == null
            ? SpinKitRing(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              )
            : FutureProvider<GameSummary?>.value(
                initialData: null,
                value: calculateSummary(game, gameModel.scores!),
                child: Summary(
                  game: game,
                  players: gameModel.players!,
                  scores: gameModel.scores!,
                  winners: WinnerList(
                    winners: gameModel.winners,
                    textColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
      ],
    );
  }
}
