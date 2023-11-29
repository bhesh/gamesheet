class Player {
  final int? id;
  final String name;
  final int gameId;

  const Player({
    required this.name,
    required this.gameId,
  }) : this.id = null;

  Player.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.name = map['name'],
        this.gameId = map['gameId'];

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
      'gameId': gameId,
    };
    if (id != null) map['id'] = id!;
    return map;
  }
}
