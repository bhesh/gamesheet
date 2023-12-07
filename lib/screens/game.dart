import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/provider/game.dart';
import 'package:gamesheet/provider/score.dart';
import 'package:provider/provider.dart';
import './game/scaffold.dart';

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => GameProvider(game),
        builder: (context, _) {
          final gameProvider = Provider.of<GameProvider>(context);
          return gameProvider.players == null
              ? GameScaffold(game: game)
              : ChangeNotifierProvider(
                  create: (_) => ScoreProvider(game, gameProvider.players!),
                  child: GameScaffold(game: game),
                );
        },
      ),
    );
  }
}
