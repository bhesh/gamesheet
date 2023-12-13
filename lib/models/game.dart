import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/common/score.dart';
import 'package:gamesheet/db/game.dart';

class GameModel extends ChangeNotifier {
  final Game game;
  final List<bool> _isComplete;
  List<Player>? _players;
  HashMap<int, Score>? _scores;
  List<int>? _winners;

  GameModel(this.game)
      : assert(game.id != null),
        this._isComplete = List.filled(game.numRounds, false) {
    _initialize();
  }

  UnmodifiableListView<Player>? get players =>
      _players == null ? null : UnmodifiableListView(_players!);

  UnmodifiableListView<bool> get complete => UnmodifiableListView(_isComplete);

  UnmodifiableMapView<int, Score>? get scores =>
      _scores == null ? null : UnmodifiableMapView(_scores!);

  UnmodifiableListView<int>? get winners =>
      _winners == null ? null : UnmodifiableListView(_winners!);

  Player? updatePlayer({
    required int playerId,
    String? name,
    Palette? color,
  }) {
    if (_players != null) {
      for (int i = 0; i < _players!.length; ++i) {
        if (_players![i].id == playerId) {
          _players![i] = _players![i].copyWith(name: name, color: color);
          GameDatabase.updatePlayer(_players![i]);
          notifyListeners();
          return _players![i];
        }
      }
    }
    return null;
  }

  bool isRoundComplete(int round) {
    assert(round < complete.length);
    return complete[round];
  }

  void updateScore(Round round) {
    if (_scores != null) {
      assert(_scores!.containsKey(round.playerId));
      _scores![round.playerId]!.setRound(round);
      _updateWinners();
    }
  }

  void completeRound(int round, [bool complete = true]) {
    assert(round < game.numRounds);
    _isComplete[round] = complete;
    notifyListeners();
  }

  Future<void> _initialize() async {
    await _initializePlayers();
    await _initializeScores();
    await _updateWinners();
  }

  Future<void> _initializePlayers() async {
    var players = await GameDatabase.getPlayers(game.id!);
    players.sort((a, b) => a.id.compareTo(b.id));
    assert(players.isNotEmpty);
    _players = players;
  }

  Future<void> _initializeScores() async {
    assert(_players != null);
    _scores = HashMap();
    _players!.forEach((player) {
      _scores![player.id] = Score(game.numRounds, game.scoring);
    });
    var rounds = await GameDatabase.getRounds(game.id!);
    List<int> numComplete = List.filled(game.numRounds, 0);
    rounds.forEach((round) {
      assert(_scores!.containsKey(round.playerId));
      assert(round.round < game.numRounds);
      _scores![round.playerId]!.setRound(round);
      if (game.hasBids && round.bid != null && round.score != null)
        numComplete[round.round] += 1;
      else if (!game.hasBids && round.score != null)
        numComplete[round.round] += 1;
    });
    for (int i = 0; i < game.numRounds; ++i)
      _isComplete[i] = numComplete[i] == game.numPlayers;
  }

  Future<void> _updateWinners() async {
    if (players != null && scores != null) {
      assert(players!.isNotEmpty);
      Score winningScore = scores![players![0].id!]!;
      scores!.values.forEach((score) {
        if (score.compareScoreTo(winningScore) < 0) winningScore = score;
      });
      List<int> winners = List.empty(growable: true);
      for (int i = 0; i < game.numPlayers; ++i) {
        if (scores![players![i].id!]!.compareScoreTo(winningScore) == 0)
          winners.add(i);
      }
      _winners = winners.length < game.numPlayers ? winners : [];
      notifyListeners();
    }
  }
}
