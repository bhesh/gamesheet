import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/games/score.dart';
import 'package:gamesheet/common/games/ping.dart';
import 'package:gamesheet/common/games/train.dart';
import 'package:gamesheet/common/games/wizard.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/db/game.dart';

HashMap<int, Score> _initScores(Game game, List<Player> players) {
  HashMap<int, Score> scores = HashMap();
  final numRounds = game.numRounds(players.length);
  switch (game.type) {
    case GameType.train:
      players.forEach((player) {
        assert(player.id != null);
        scores[player.id!] = TrainScore(numRounds);
      });
    case GameType.ping:
      players.forEach((player) {
        assert(player.id != null);
        scores[player.id!] = PingScore(numRounds);
      });
    case GameType.wizard:
      players.forEach((player) {
        assert(player.id != null);
        scores[player.id!] = WizardScore(numRounds);
      });
  }
  return scores;
}

List<bool> _initComplete(Game game, List<Player> players) {
  return List.filled(game.numRounds(players.length), false);
}

class ScoreModel extends ChangeNotifier {
  final Game game;
  final List<Player> players;
  final HashMap<int, Score> _scores;
  final List<bool> _isComplete;
  List<Player>? _winners;

  ScoreModel(this.game, this.players)
      : assert(game.id != null),
        this._scores = _initScores(game, players),
        this._isComplete = _initComplete(game, players) {
    initialize();
  }

  UnmodifiableMapView<int, Score> get scores => UnmodifiableMapView(_scores);

  UnmodifiableListView<bool> get complete => UnmodifiableListView(_isComplete);

  UnmodifiableListView<Player>? get winners =>
      _winners == null ? null : UnmodifiableListView(_winners!);

  Future<void> initialize() async {
    final numRounds = game.numRounds(players.length);
    var rounds = await GameDatabase.getRounds(game.id!);
    List<int> numComplete = List.filled(numRounds, 0);
    rounds.forEach((round) {
      assert(_scores.containsKey(round.playerId));
      assert(round.round < numRounds);
      _scores[round.playerId]!.setRound(round);
      numComplete[round.round] += 1;
    });
    for (int i = 0; i < numRounds; ++i)
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
      final numRounds = game.numRounds(players.length);
      int winningScore = scores[players[0].id!]!.totalScore;
      scores.values.forEach((score) {
        final totalScore = score.totalScore;
        if (score.compareScores(totalScore, winningScore) < 0)
          winningScore = totalScore;
      });
      var winners = players.where((player) {
        return scores[player.id!]!.totalScore == winningScore;
      }).toList();
      _winners = winners.length < players.length ? winners : [];
      notifyListeners();
    }
  }
}
