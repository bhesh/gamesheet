import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/games/game_player.dart';
import './score_bar.dart';

enum BarGraphType {
  round,
  total,
  average;
}

class BarGraph extends StatefulWidget {
  final Game game;
  final List<GamePlayer> players;
  final BarGraphType type;
  final int? round;

  const BarGraph({
    super.key,
    required this.game,
    required this.players,
    required this.round,
  }) : this.type = BarGraphType.round;

  const BarGraph.total({
    super.key,
    required this.game,
    required this.players,
  })  : this.type = BarGraphType.total,
        this.round = null;

  const BarGraph.average({
    super.key,
    required this.game,
    required this.players,
  })  : this.type = BarGraphType.average,
        this.round = null;

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late final List<int> _values;
  int? _maxValue;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _values = List.filled(widget.players.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _maxValue = null;
      _values.fillRange(0, _values.length, 0);
      _calculateValues().then((_) => setState(() => _initialized = true));
    }
    return Column(children: _buildChildren(context));
  }

  List<Widget> _buildChildren(BuildContext context) {
    if (_initialized) assert(_values.length == widget.players.length);
    List<Widget> children = List.empty(growable: true);
    for (int i = 0; i < widget.players.length; ++i) {
      children.add(ScoreBar(
        name: widget.players[i].name,
        color: widget.players[i].color,
        value: _values[i],
        maxValue: _maxValue ?? 0,
      ));
    }
    return children;
  }

  Future _calculateValues() async {
    switch (widget.type) {
      case BarGraphType.round:
        assert(widget.round != null);
        await _calculateRoundValues(widget.round!);
      case BarGraphType.total:
        print('Recalculating total bar graph');
        await _calculateTotalValues();
      case BarGraphType.average:
        await _calculateAverageValues();
    }
  }

  Future _calculateRoundValues(int round) async {
    assert(widget.players.isNotEmpty);
    int maxValue = widget.players[0].getScore(round);
    for (int i = 0; i < widget.players.length; ++i) {
      _values[i] = widget.players[i].getScore(round);
      if (_values[i] > maxValue) maxValue = _values[i];
    }
    _maxValue = maxValue;
  }

  Future _calculateTotalValues() async {
    assert(widget.players.isNotEmpty);
    int maxValue = widget.players[0].totalScore;
    for (int i = 0; i < widget.players.length; ++i) {
      _values[i] = widget.players[i].totalScore;
      if (_values[i] > maxValue) maxValue = _values[i];
    }
    _maxValue = maxValue;
  }

  Future _calculateAverageValues() async {
    assert(widget.players.isNotEmpty);
    int numRounds = widget.game.numRounds(widget.players.length);
    int maxValue = widget.players[0].totalScore ~/ numRounds;
    for (int i = 0; i < widget.players.length; ++i) {
      _values[i] = widget.players[i].totalScore ~/ numRounds;
      if (_values[i] > maxValue) maxValue = _values[i];
    }
    _maxValue = maxValue;
  }
}
