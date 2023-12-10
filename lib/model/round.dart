import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/db/game.dart';

class RoundModel extends ChangeNotifier {
  final Game game;
  final int index;
  HashMap<int, Round>? _round;

  RoundModel(this.game, this.index) : assert(game.id != null) {
    initialize();
  }

  UnmodifiableMapView<int, Round>? get round =>
      _round == null ? null : UnmodifiableMapView(_round!);

  Future<void> initialize() async {
    var rounds = await GameDatabase.getRound(game.id!, index);
    _round = HashMap();
    rounds.forEach((round) => _round![round.playerId] = round);
    notifyListeners();
  }

  Round? updateBid(int playerId, int bid) {
    if (_round != null) {
      Round? oldRound = _round![playerId];
      if (oldRound?.bid != bid) {
        Round newRound = oldRound?.copyWith(bid: bid) ??
            Round(
              gameId: game.id!,
              playerId: playerId,
              round: index,
              score: -1,
              bid: bid,
            );
        _round![playerId] = newRound;
        GameDatabase.updateRound(newRound);
        return newRound;
      }
    }
    return null;
  }

  Round? updateScore(int playerId, int score) {
    if (_round != null) {
      Round? oldRound = _round![playerId];
      if (oldRound?.score != score) {
        Round newRound = oldRound?.copyWith(score: score) ??
            Round(
              gameId: game.id!,
              playerId: playerId,
              round: index,
              score: score,
              bid: -1,
            );
        _round![playerId] = newRound;
        GameDatabase.updateRound(newRound);
        return newRound;
      }
    }
    return null;
  }
}
