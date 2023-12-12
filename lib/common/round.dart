class Round {
  final int gameId;
  final int playerId;
  final int round;
  final int? bid;
  final int? score;

  const Round({
    required this.gameId,
    required this.playerId,
    required this.round,
    this.bid,
    this.score,
  });

  factory Round.fromMap(Map<String, dynamic> map) {
    return Round(
      gameId: map['gameId'],
      playerId: map['playerId'],
      round: map['round'],
      bid: map['bid'] < 0 ? null : map['bid'],
      score: map['score'] < 0 ? null : map['score'],
    );
  }

  Round copyWith({
    int? bid,
    int? score,
    bool overwrite = false,
  }) {
    return Round(
      gameId: this.gameId,
      playerId: this.playerId,
      round: this.round,
      bid: overwrite ? bid : bid ?? this.bid,
      score: overwrite ? score : score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'gameId': gameId,
      'playerId': playerId,
      'round': round,
      'bid': bid == null ? -1 : bid,
      'score': score == null ? -1 : score,
    };
    return map;
  }
}
