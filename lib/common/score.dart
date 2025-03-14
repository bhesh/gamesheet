import 'dart:math';
import './game.dart';
import './round.dart';

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

  int get highestScore => scores.fold(-2147000000, (a, b) => max(a, b));

  int get lowestScore => scores.fold(2147000000, (a, b) => min(a, b));

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
