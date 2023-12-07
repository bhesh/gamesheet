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

HashMap<int, Score> _buildScores(Game game, List<Player> players) {
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

class ScoreProvider extends ChangeNotifier {
  final Game game;
  final List<Player> players;
  final HashMap<int, Score> _scores;
  List<Player>? _winners;

  ScoreProvider(this.game, this.players)
      : assert(game.id != null),
        this._scores = _buildScores(game, players);

  UnmodifiableMapView<int, Score> get scores => UnmodifiableMapView(_scores);

  UnmodifiableListView<Player>? get winners =>
      _winners == null ? null : UnmodifiableListView(_winners!);

  void initialize() {
    GameDatabase.getRounds(game.id!).then((rounds) {
      rounds.forEach((round) {
        assert(_scores.containsKey(round.playerId));
        _scores[round.playerId]!.setRound(round);
      });
      _updateWinners();
    });
  }

  void updateScore(Round round) {
    assert(_scores.containsKey(round.playerId));
    _scores[round.playerId]!.setRound(round);
    _updateWinners();
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