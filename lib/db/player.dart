import 'package:gamesheet/db/color.dart';

class Player {
  final int? id;
  final String name;
  final GameColor color;
  final int gameId;

  const Player({
    required this.name,
    required this.color,
    required this.gameId,
  }) : this.id = null;

  Player.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.name = map['name'],
        this.color = GameColor.fromId(map['color']),
        this.gameId = map['gameId'];

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
