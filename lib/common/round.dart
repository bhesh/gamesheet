class Round {
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
  });

  const Round.raw({
    required this.gameId,
    required this.playerId,
    required this.round,
    required this.bid,
    required this.score,
  });

  Round.fromMap(Map<String, dynamic> map)
      : this.gameId = map['gameId'],
        this.playerId = map['playerId'],
        this.round = map['round'],
        this.bid = map['bid'],
        this.score = map['score'];

  Round copyWith({
    int? gameId,
    int? playerId,
    int? round,
    int? bid,
    int? score,
  }) {
    return Round.raw(
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
    return map;
  }
}
