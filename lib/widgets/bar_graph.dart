import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/score.dart';

enum BarGraphType {
  total,
  highest,
  lowest,
  player;
}

class BarGraph extends StatelessWidget {
  // Common values
  final BarGraphType type;
  final Game game;
  final num? minValue;
  final num? maxValue;

  // total/average values
  final List<Player>? players;
  final Map<int, Score>? scores;
  final void Function(Player)? onTap;

  // player values
  final Score? score;
  final int? initialColor;

  const BarGraph.total({
    super.key,
    required this.game,
    this.minValue,
    this.maxValue,
    required List<Player> players,
    required Map<int, Score> scores,
    this.onTap,
  })  : this.type = BarGraphType.total,
        this.players = players,
        this.scores = scores,
        this.score = null,
        this.initialColor = null;

  const BarGraph.highest({
    super.key,
    required this.game,
    this.minValue,
    this.maxValue,
    required List<Player> players,
    required Map<int, Score> scores,
    this.onTap,
  })  : this.type = BarGraphType.highest,
        this.players = players,
        this.scores = scores,
        this.score = null,
        this.initialColor = null;

  const BarGraph.lowest({
    super.key,
    required this.game,
    this.minValue,
    this.maxValue,
    required List<Player> players,
    required Map<int, Score> scores,
    this.onTap,
  })  : this.type = BarGraphType.lowest,
        this.players = players,
        this.scores = scores,
        this.score = null,
        this.initialColor = null;

  const BarGraph.player({
    super.key,
    required this.game,
    this.minValue,
    this.maxValue,
    this.score,
    this.initialColor,
  })  : this.type = BarGraphType.player,
        this.players = null,
        this.scores = null,
        this.onTap = null;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    if (type == BarGraphType.total || type == BarGraphType.highest || type == BarGraphType.lowest) {
      assert(players != null);
      assert(scores != null);
      for (int i = 0; i < players!.length; ++i) {
        Player player = players![i];
        Score? score = maxValue == null ? null : scores![player.id];
        switch (type) {
          case BarGraphType.total:
            children.add(_ScoreBar(
              name: player.name,
              color: player.color,
              value: score?.totalScore ?? 0,
              minValue: minValue ?? 0,
              maxValue: maxValue ?? 0,
              onTap: () => onTap == null ? null : onTap!(player),
            ));
          case BarGraphType.highest:
            children.add(_ScoreBar(
              name: player.name,
              color: player.color,
              value: score?.highestScore ?? 0,
              minValue: minValue ?? 0,
              maxValue: maxValue ?? 0,
              onTap: () => onTap == null ? null : onTap!(player),
            ));
          case BarGraphType.lowest:
            children.add(_ScoreBar(
              name: player.name,
              color: player.color,
              value: score?.lowestScore ?? 0,
              minValue: minValue ?? 0,
              maxValue: maxValue ?? 0,
              onTap: () => onTap == null ? null : onTap!(player),
            ));
          default:
            assert(false, 'should not be reachable');
        }
      }
    } else {
      int startingColor =
          initialColor ?? Random().nextInt(Palette.values.length);
      for (int i = 0; i < game.numRounds; ++i) {
        children.add(_ScoreBar(
          name: 'Round ${game.roundLabels[i]}',
          color: Palette.values[(startingColor + i) % Palette.values.length],
          value: score?.getScore(i) ?? 0,
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
  final void Function()? onTap;

  const _ScoreBar({
    super.key,
    required this.name,
    required this.color,
    required this.value,
    required this.minValue,
    required this.maxValue,
    this.onTap,
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
          return InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: onTap,
            child: Stack(
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
            ),
          );
        },
      ),
    );
  }
}
