import './color.dart';

class Player {
  final int? id;
  final int gameId;
  final String name;
  final Palette color;

  const Player({
    required this.name,
    required this.color,
    required this.gameId,
  }) : this.id = null;

  const Player.raw({
    required this.id,
    required this.gameId,
    required this.name,
    required this.color,
  });

  Player.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.gameId = map['gameId'],
        this.name = map['name'],
        this.color = Palette.fromId(map['color']);

  Player copyWith({
    int? id,
    String? name,
    Palette? color,
    int? gameId,
  }) {
    return Player.raw(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
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
