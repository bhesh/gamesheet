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
import 'package:gamesheet/widgets/avatar.dart';

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

class ScoreProvider extends ChangeNotifier {
  final Game game;
  final List<Player> players;
  final HashMap<int, Score> _scores;
  final List<bool> _isComplete;
  List<Player>? _winners;

  ScoreProvider(this.game, this.players)
      : assert(game.id != null),
        this._scores = _initScores(game, players),
        this._isComplete = _initComplete(game, players);

  UnmodifiableMapView<int, Score> get scores => UnmodifiableMapView(_scores);

  UnmodifiableListView<bool> get complete => UnmodifiableListView(_isComplete);

  UnmodifiableListView<Player>? get winners =>
      _winners == null ? null : UnmodifiableListView(_winners!);

  void initialize() {
    Future(() async {
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
    }).then((_) => _updateWinners());
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

  Widget buildWinnerWidget(BuildContext context, Color textColor,
      [bool border = false]) {
    List<Widget> children = [Spacer()];
    if (winners == null || winners!.isEmpty)
      children.add(
        Text('No winners',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: textColor)),
      );
    else {
      winners!.take(5).forEach((player) {
        var avatar = GamesheetAvatar(
          name: player.name,
          color: player.color,
        );
        children.add(Padding(
            padding: EdgeInsets.all(5),
            child: border
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 21,
                    child: avatar,
                  )
                : avatar));
      });
      if (winners!.length > 5) {
        children.add(Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            '...',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: textColor),
          ),
        ));
      }
    }
    children.add(Spacer());
    return Row(children: children);
  }

  void _updateWinners() {
    if (scores != null) {
      _calculate().then((winners) {
        _winners = winners;
        notifyListeners();
      });
    }
  }

  Future<List<Player>> _calculate() async {
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
    return winners.length < players.length ? winners : [];
  }
}
