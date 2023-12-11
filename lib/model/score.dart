import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/score.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/db/game.dart';

HashMap<int, Score> _initScores(Game game, List<Player> players) {
  HashMap<int, Score> scores = HashMap();
  players.forEach((player) {
    assert(player.id != null);
    scores[player.id!] = Score(game.numRounds, game.scoring);
  });
  return scores;
}

class ScoreModel extends ChangeNotifier {
  final Game game;
  final List<Player> _players;
  final HashMap<int, Score> _scores;
  final List<bool> _isComplete;
  List<Player>? _winners;

  ScoreModel(this.game, this._players)
      : assert(game.id != null),
        this._scores = _initScores(game, _players),
        this._isComplete = List.filled(game.numRounds, false) {
    initialize();
  }

  UnmodifiableListView<Player> get players => UnmodifiableListView(_players);

  UnmodifiableMapView<int, Score> get scores => UnmodifiableMapView(_scores);

  UnmodifiableListView<bool> get complete => UnmodifiableListView(_isComplete);

  UnmodifiableListView<Player>? get winners =>
      _winners == null ? null : UnmodifiableListView(_winners!);

  Future<void> initialize() async {
    var rounds = await GameDatabase.getRounds(game.id!);
    List<int> numComplete = List.filled(game.numRounds, 0);
    rounds.forEach((round) {
      assert(_scores.containsKey(round.playerId));
      assert(round.round < game.numRounds);
      _scores[round.playerId]!.setRound(round);
      numComplete[round.round] += 1;
    });
    for (int i = 0; i < game.numRounds; ++i)
      _isComplete[i] = numComplete[i] == players.length;
    await _updateWinners();
  }

  void updateScore(Round round) {
    assert(_scores.containsKey(round.playerId));
    _scores[round.playerId]!.setRound(round);
    _updateWinners();
  }

  void updateRound(int round, bool isComplete) {
    assert(round < _isComplete.length);
    _isComplete[round] = isComplete;
    notifyListeners();
  }

  bool isComplete(int round) {
    assert(round < _isComplete.length);
    return _isComplete[round];
  }

  Future<void> _updateWinners() async {
    if (scores != null) {
      assert(players.isNotEmpty);
      Score winningScore = scores[players[0].id!]!;
      scores.values.forEach((score) {
        if (score.compareScoreTo(winningScore) < 0) winningScore = score;
      });
      var winners = players.where((player) {
        return scores[player.id!]!.compareScoreTo(winningScore) == 0;
      }).toList();
      _winners = winners.length < players.length ? winners : [];
      notifyListeners();
    }
  }
}
