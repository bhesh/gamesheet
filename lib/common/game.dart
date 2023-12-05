import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum GameType {
  train(1, 'Train', Symbols.directions_subway),
  ping(2, 'Ping', Symbols.playing_cards),
  wizard(3, 'Wizard', Symbols.settings_accessibility);

  final int id;
  final String label;
  final IconData icon;

  const GameType(this.id, this.label, this.icon);

  factory GameType.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}

class Game {
  final int? id;
  final String name;
  final GameType type;
  final DateTime created;

  const Game({
    required this.name,
    required this.type,
    required this.created,
  }) : this.id = null;

  Game.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.name = map['name'],
        this.type = GameType.fromId(map['type']),
        this.created = DateTime.fromMillisecondsSinceEpoch(map['created']);

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
      'type': type.id,
      'created': created.millisecondsSinceEpoch,
    };
    if (id != null) map['id'] = id!;
    return map;
  }

  int numRounds(int numPlayers) {
    switch (type) {
      case GameType.train:
        return 13;
      case GameType.ping:
        return 11;
      case GameType.wizard:
        return 60 ~/ numPlayers;
    }
  }

  List<String> roundLabels(int numPlayers) {
    switch (type) {
      case GameType.train:
        return List.generate(13, (index) => '${13 - index - 1}');
      case GameType.ping:
        return [
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
        ];
      case GameType.wizard:
        return List.generate(numRounds(numPlayers), (index) => '${index + 1}');
    }
  }

  String get bidText => 'bid';

  String get scoreText => type == GameType.wizard ? 'tricks' : 'score';
}
