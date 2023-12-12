import './color.dart';

class Player {
  final int id;
  final int gameId;
  final String name;
  final Palette color;

  const Player({
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
    return Player(
      id: this.id,
      gameId: this.gameId,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'name': name,
      'color': color.id,
    };
  }
}
