import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/score.dart';

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
    List<Widget> children = List.empty(growable: true);
    for (int i = 0; i < players.length; ++i) {
      Player player = players[i];
      assert(player.id != null);
      Score? score = maxValue == null ? null : scores[player.id!];
      switch (type) {
        case BarGraphType.round:
          assert(round != null);
          children.add(_ScoreBar(
            name: player.name,
            color: player.color,
            value: score?.getScore(round!) ?? 0,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 0,
          ));
        case BarGraphType.total:
          children.add(_ScoreBar(
            name: player.name,
            color: player.color,
            value: score?.totalScore ?? 0,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 0,
          ));
        case BarGraphType.average:
          children.add(_ScoreBar(
            name: player.name,
            color: player.color,
            value: score == null ? 0 : score!.totalScore / game.numRounds,
            minValue: minValue ?? 0,
            maxValue: maxValue ?? 0,
          ));
      }
    }
    return Column(children: children);
  }
}

class _ScoreBar extends StatelessWidget {
  final String name;
  final Palette color;
  final num value;
  final num minValue;
  final num maxValue;

  const _ScoreBar({
    super.key,
    required this.name,
    required this.color,
    required this.value,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the padding and size
          var width = constraints.biggest.width;
          num calcMinValue = minValue > 0 ? 0 : minValue;
          num calcMaxValue = maxValue < 0 ? 0 : maxValue;
          num range = calcMinValue.abs() + calcMaxValue;
          num padding = range == 0
              ? 0 // don't divide by 0
              : value < 0
                  ? (width * (calcMinValue.abs() + value)) / range
                  : (width * calcMinValue.abs()) / range;
          Widget bar = Padding(
            padding: EdgeInsets.only(left: padding.toDouble()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 40,
              width: range == 0 ? 0 : (width * value.abs()) / range,
              decoration: BoxDecoration(
                color: addEmphasis(
                  Theme.of(context).brightness == Brightness.light,
                  color.background,
                  50,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );

          // Return stack
          return Stack(
            children: <Widget>[
              bar,
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: width * 0.75,
                      child: Text(
                        '${name}',
                        style: Theme.of(context).textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      value.runtimeType == double
                          ? value.toStringAsFixed(2)
                          : '$value',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
