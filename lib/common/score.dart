import './round.dart';

enum Scoring {
  lowest(1, 'Lowest Score'),
  highest(2, 'Highest Score'),
  wizard(3, 'Wizard Scoring');

  final int id;
  final String label;

  const Scoring(this.id, this.label);

  factory Scoring.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }

  int calculate(int bid, int score) {
    switch (this) {
      case Scoring.lowest:
        return score < 0 ? 0 : score;
      case Scoring.highest:
        return score < 0 ? 0 : score;
      case Scoring.wizard:
        if (bid < 0 || score < 0) return 0;
        if (bid == score) return (bid + 2) * 10;
        return (bid - score).abs() * -10;
    }
  }

  /// negative number if left score is winning
  /// 0 if scores are tied
  /// positive number if right score is winning
  int compareScores(int leftScore, int rightScore) {
    switch (this) {
      case Scoring.lowest:
        if (leftScore < rightScore) return -1;
        if (leftScore == rightScore) return 0;
        return 1;
      default:
        if (leftScore < rightScore) return 1;
        if (leftScore == rightScore) return 0;
        return -1;
    }
  }
}

class Score {
  final int numRounds;
  final Scoring scoring;
  final List<int> scores;

  Score(this.numRounds, this.scoring) : this.scores = List.filled(numRounds, 0);

  void setRound(Round round) {
    assert(round.round < scores.length);
    scores[round.round] = scoring.calculate(round.bid, round.score);
  }

  int getScore(int round) {
    assert(round < scores.length);
    return scores[round];
  }

  int get totalScore => scores.fold(0, (a, b) => a + b);

  /// negative number if this player is winning
  /// 0 if players are tied
  /// positive number if this player is losing
  int compareScoreTo(Score other, [int? round = null]) {
    if (round == null)
      return scoring.compareScores(totalScore, other.totalScore);
    assert(round! < numRounds);
    return scoring.compareScores(getScore(round!), other.getScore(round!));
  }
}
