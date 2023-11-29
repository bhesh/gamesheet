import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum GameType {
  train(1, 'Train', Symbols.casino),
  ping(2, 'Ping', Symbols.playing_cards);

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

  const Game({
    required this.name,
    required this.type,
  }) : this.id = null;

  Game.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.name = map['name'],
        this.type = GameType.fromId(map['type']);

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
      'type': type.id,
    };
    if (id != null) map['id'] = id!;
    return map;
  }
}
