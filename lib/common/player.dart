import './color.dart';

class Player {
  final int? id;
  final int gameId;
  final String name;
  final Palette color;

  const Player({
    this.id,
    required this.name,
    required this.color,
    required this.gameId,
  });

  const Player.raw({
    required this.id,
    required this.gameId,
    required this.name,
    required this.color,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      gameId: map['gameId'],
      name: map['name'],
      color: Palette.fromId(map['color']),
    );
  }

  Player copyWith({
    String? name,
    Palette? color,
  }) {
    return Player.raw(
      id: this.id,
      gameId: this.gameId,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
      'color': color.id,
      'gameId': gameId,
    };
    if (id != null) map['id'] = id!;
    return map;
  }
}
