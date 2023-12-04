class Round {
  final int? id;
  final int gameId;
  final int playerId;
  final int round;
  final int bid;
  final int score;

  const Round({
    required this.gameId,
    required this.playerId,
    required this.round,
    this.bid = -1,
    this.score = -1,
  }) : this.id = null;

  const Round.raw({
    required this.gameId,
    required this.playerId,
    required this.round,
    required this.id,
    required this.bid,
    required this.score,
  });

  Round.fromMap(Map<String, dynamic> map)
      : this.id = map['id'],
        this.gameId = map['gameId'],
        this.playerId = map['playerId'],
        this.round = map['round'],
        this.bid = map['bid'],
        this.score = map['score'];

  Round copyWith({
    int? id,
    int? gameId,
    int? playerId,
    int? round,
    int? bid,
    int? score,
  }) {
    return Round.raw(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      round: round ?? this.round,
      bid: bid ?? this.bid,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'gameId': gameId,
      'playerId': playerId,
      'round': round,
      'bid': bid,
      'score': score,
    };
    if (id != null) map['id'] = id!;
    return map;
  }
}
