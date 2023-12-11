import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import './score.dart';

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

class Game {
  final int? id;
  final String name;
  final GameType type;
  final int numPlayers;
  final int numRounds;
  final UnmodifiableListView<String> roundLabels;
  final Scoring scoring;
  final int dealer;
  final DateTime created;

  Game.raw({
    required int id,
    required this.name,
    required this.type,
    required this.numPlayers,
    required this.numRounds,
    required this.scoring,
    required this.dealer,
    required this.created,
  })  : this.id = id,
        this.roundLabels = type.roundLabels(numRounds),
        assert(dealer == -1 || dealer! < numPlayers);

  Game.train({
    required this.name,
    required this.numPlayers,
  })  : this.id = null,
        this.type = GameType.train,
        this.numRounds = 13,
        this.roundLabels = GameType.train.roundLabels(13),
        this.scoring = Scoring.lowest,
        this.dealer = -1,
        this.created = DateTime.now();

  Game.ping({
    required this.name,
    required this.numPlayers,
    required this.dealer,
  })  : this.id = null,
        this.type = GameType.ping,
        this.numRounds = 11,
        this.roundLabels = GameType.ping.roundLabels(11),
        this.scoring = Scoring.lowest,
        this.created = DateTime.now(),
        assert(dealer! < numPlayers);

  Game.wizard({
    required this.name,
    required this.numPlayers,
    required this.dealer,
  })  : this.id = null,
        this.type = GameType.wizard,
        this.numRounds = 60 ~/ numPlayers,
        this.roundLabels = GameType.wizard.roundLabels(60 ~/ numPlayers),
        this.scoring = Scoring.wizard,
        this.created = DateTime.now(),
        assert(dealer! < numPlayers);

  Game.custom({
    required this.name,
    required this.numPlayers,
    required this.numRounds,
    required this.scoring,
    this.dealer = -1,
  })  : this.id = null,
        this.type = GameType.custom,
        this.roundLabels = GameType.custom.roundLabels(numRounds),
        this.created = DateTime.now();

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game.raw(
      id: map['id'],
      name: map['name'],
      type: GameType.fromId(map['type']),
      numPlayers: map['numPlayers'],
      numRounds: map['numRounds'],
      scoring: Scoring.fromId(map['scoring']),
      dealer: map['dealer'],
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
      'created': created.millisecondsSinceEpoch,
    };
    if (id != null) map['id'] = id!;
    if (dealer != null) map['dealer'] = dealer!;
    return map;
  }

  bool get hasDealer => dealer != null;

  bool get hasBids => type == GameType.wizard;

  String get bidText => 'bid';

  String get scoreText => hasBids ? 'tricks' : 'score';
}
