import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum GameType {
  train(1, 'Train', Symbols.casino),
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
}
