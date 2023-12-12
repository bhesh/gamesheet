import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum GameType {
  train(1, 'Train', Symbols.directions_subway),
  ping(2, 'Ping', Symbols.playing_cards),
  wizard(3, 'Wizard', Symbols.settings_accessibility),
  custom(99, 'Custom', Symbols.extension);

  final int id;
  final String label;
  final IconData icon;

  const GameType(this.id, this.label, this.icon);

  factory GameType.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }

  UnmodifiableListView<String> roundLabels(int numRounds) {
    switch (this) {
      case GameType.train:
        return UnmodifiableListView(List.generate(
          13,
          (index) => '${13 - index - 1}',
        ));
      case GameType.ping:
        return UnmodifiableListView([
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          'J',
          'Q',
          'K',
        ]);
      default:
        return UnmodifiableListView(List.generate(
          numRounds,
          (index) => '${index + 1}',
        ));
    }
  }
}

enum Scoring {
  lowest(1, 'Lowest Score'),
  highest(2, 'Highest Score'),
  wizard(3, 'Wizard Scoring');

  final int id;
  final String label;

  const Scoring(this.id, this.label);

  factory Scoring.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }

  int calculate(int? bid, int? score) {
    switch (this) {
      case Scoring.lowest:
        return score ?? 0;
      case Scoring.highest:
        return score ?? 0;
      case Scoring.wizard:
        if (bid == null || score == null) return 0;
        if (bid! == score!) return (bid! + 2) * 10;
        return (bid! - score!).abs() * -10;
    }
  }

  /// negative number if left score is winning
  /// 0 if scores are tied
  /// positive number if right score is winning
  int compareScores(int leftScore, int rightScore) {
    switch (this) {
      case Scoring.lowest:
        if (leftScore < rightScore) return -1;
        if (leftScore == rightScore) return 0;
        return 1;
      default:
        if (leftScore < rightScore) return 1;
        if (leftScore == rightScore) return 0;
        return -1;
    }
  }
}

class Game {
  final int? id;
  final String name;
  final GameType type;
  final int numPlayers;
  final int numRounds;
  final UnmodifiableListView<String> roundLabels;
  final Scoring scoring;
  final int? dealer;
  final DateTime created;

  Game({
    this.id,
    required this.name,
    required this.type,
    required this.numPlayers,
    required this.numRounds,
    required this.scoring,
    this.dealer,
    required this.created,
  })  : this.roundLabels = type.roundLabels(numRounds),
        assert(dealer == null || dealer! < numPlayers);

  Game.train({
    this.id,
    required this.name,
    required this.numPlayers,
  })  : this.type = GameType.train,
        this.numRounds = 13,
        this.roundLabels = GameType.train.roundLabels(13),
        this.scoring = Scoring.lowest,
        this.dealer = null,
        this.created = DateTime.now();

  Game.ping({
    this.id,
    required this.name,
    required this.numPlayers,
    required int dealer,
  })  : this.type = GameType.ping,
        this.numRounds = 11,
        this.roundLabels = GameType.ping.roundLabels(11),
        this.scoring = Scoring.lowest,
        this.created = DateTime.now(),
        assert(dealer < numPlayers),
        this.dealer = dealer;

  Game.wizard({
    this.id,
    required this.name,
    required this.numPlayers,
    required int dealer,
  })  : this.type = GameType.wizard,
        this.numRounds = 60 ~/ numPlayers,
        this.roundLabels = GameType.wizard.roundLabels(60 ~/ numPlayers),
        this.scoring = Scoring.wizard,
        this.created = DateTime.now(),
        assert(dealer < numPlayers),
        this.dealer = dealer;

  Game.custom({
    this.id,
    required this.name,
    required this.numPlayers,
    required this.numRounds,
    required this.scoring,
    this.dealer,
  })  : this.type = GameType.custom,
        this.roundLabels = GameType.custom.roundLabels(numRounds),
        this.created = DateTime.now();

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'],
      type: GameType.fromId(map['type']),
      numPlayers: map['numPlayers'],
      numRounds: map['numRounds'],
      scoring: Scoring.fromId(map['scoring']),
      dealer: map['dealer'] == -1 ? null : map['dealer'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
      'type': type.id,
      'numPlayers': numPlayers,
      'numRounds': numRounds,
      'scoring': scoring.id,
      'dealer': dealer == null ? -1 : dealer,
      'created': created.millisecondsSinceEpoch,
    };
    if (id != null) map['id'] = id!;
    return map;
  }

  bool get hasDealer => dealer != null;

  bool get hasBids => scoring == Scoring.wizard;

  String get bidText => 'bid';

  String get scoreText => hasBids ? 'tricks' : 'score';
}
