import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/games/score.dart';
import './score_bar.dart';

enum BarGraphType {
  round,
  total,
  average;
}

class BarGraph extends StatelessWidget {
  final BarGraphType type;
  final Game game;
  final List<Player> players;
  final Map<int, Score> scores;
  final int? round;
  final num? minValue;
  final num? maxValue;

  const BarGraph({
    super.key,
    required this.game,
    required this.players,
    required this.scores,
    required this.round,
    this.minValue,
    this.maxValue,
  }) : this.type = BarGraphType.round;

  const BarGraph.total({
    super.key,
    required this.game,
    required this.players,
    required this.scores,
    this.minValue,
    this.maxValue,
  })  : this.type = BarGraphType.total,
        this.round = null;

  const BarGraph.average({
    super.key,
    required this.game,
    required this.players,
    required this.scores,
    this.minValue,
    this.maxValue,
  })  : this.type = BarGraphType.average,
        this.round = null;

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildChildren(context));
  }

  List<Widget> _buildChildren(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    for (int i = 0; i < players.length; ++i) {
      Player player = players[i];
      assert(player.id != null);
      Score? score = maxValue == null ? null : scores[player.id!];
      switch (type) {
        case BarGraphType.round:
          assert(round != null);
          children.add(ScoreBar(
            name: player.name,
            color: player.color,
            value: score?.getScore(round!) ?? 0,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 0,
          ));
        case BarGraphType.total:
          children.add(ScoreBar(
            name: player.name,
            color: player.color,
            value: score?.totalScore ?? 0,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 0,
          ));
        case BarGraphType.average:
          final numRounds = game.numRounds(players.length);
          children.add(ScoreBar(
            name: player.name,
            color: player.color,
            value: score == null ? 0 : score!.totalScore / numRounds,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 0,
          ));
      }
    }
    return children;
  }
}
