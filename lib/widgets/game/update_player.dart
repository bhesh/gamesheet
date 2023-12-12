import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/models/game.dart';
import 'package:gamesheet/screens/player.dart';
import 'package:provider/provider.dart';

void updatePlayerScreen(BuildContext context, Game game, Player player) {
  final gameModel = Provider.of<GameModel>(context, listen: false);
  if (gameModel.scores != null) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          game: game,
          player: player,
          scores: gameModel.scores!,
          onSave: (name, color) {
            if (player.name != null || player.color != color) {
              assert(player.id != null);
              gameModel.updatePlayer(
                playerId: player.id!,
                name: name,
                color: color,
              );
            }
          },
        ),
      ),
    );
  }
}
