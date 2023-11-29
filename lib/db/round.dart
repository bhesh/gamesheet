class Round {
  final int? id;
  final int gameId;
  final int playerId;
  final int round;
  final int? bet;
  final int? score;

  const Round({
    required this.gameId,
    required this.playerId,
    required this.round,
  })  : this.id = null,
        this.bet = null,
        this.score = null;

  Round.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.gameId = map['gameId'],
        this.playerId = map['playerId'],
        this.round = map['round'],
        this.bet = map['bet'],
        this.score = map['score'];

  Map<String, dynamic> toMap() {
    var map = {
      'gameId': gameId,
      'playerId': playerId,
      'round': round,
    };
    if (id != null) map['id'] = id!;
    if (bet != null) map['bet'] = bet!;
    if (score != null) map['score'] = score!;
    return map;
  }
}
