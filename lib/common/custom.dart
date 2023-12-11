import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Scoring {
  lowest(1),
  highest(2);

  final int id;

  const Scoring(this.id);

  factory Scoring.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}

class Custom {
  final int gameId;
  final int numRounds;
  final Scoring scoring;

  const Custom({
    required this.gameId,
    required this.numRounds,
    required this.scoring,
  });

  Custom.fromMap(Map<String, dynamic> map)
      : this.gameId = map['gameId'],
        this.numRounds = map['numRounds'],
        this.scoring = Scoring.fromId(map['scoring']);

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'numRounds': numRounds,
      'scoring': scoring.id,
    };
  }
}
