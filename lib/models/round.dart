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
    _initialize();
  }

  UnmodifiableMapView<int, Round>? get round =>
      _round == null ? null : UnmodifiableMapView(_round!);

  Round? updateBid(int playerId, int? bid) {
    assert(bid == null || bid! >= 0);
    if (_round != null) {
      Round? oldRound = _round![playerId];
      if (oldRound?.bid != bid) {
        Round newRound = oldRound?.copyWith(
              bid: bid,
              score: oldRound?.score,
              overwrite: true,
            ) ??
            Round(
              gameId: game.id!,
              playerId: playerId,
              round: index,
              bid: bid,
            );
        _round![playerId] = newRound;
        GameDatabase.updateRound(newRound);
        notifyListeners();
        return newRound;
      }
    }
    return null;
  }

  Round? updateScore(int playerId, int? score) {
    assert(score == null || score! >= 0);
    if (_round != null) {
      Round? oldRound = _round![playerId];
      if (oldRound?.score != score) {
        Round newRound = oldRound?.copyWith(
              bid: oldRound?.bid,
              score: score,
              overwrite: true,
            ) ??
            Round(
              gameId: game.id!,
              playerId: playerId,
              round: index,
              score: score,
            );
        _round![playerId] = newRound;
        GameDatabase.updateRound(newRound);
        notifyListeners();
        return newRound;
      }
    }
    return null;
  }

  Future<void> _initialize() async {
    var rounds = await GameDatabase.getRound(game.id!, index);
    _round = HashMap();
    rounds.forEach((round) => _round![round.playerId] = round);
    notifyListeners();
  }
}
