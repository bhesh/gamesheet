import 'package:gamesheet/common/round.dart';

abstract class Score {
  final int numRounds;

  Score(this.numRounds);

  void setRound(Round round);

  int getScore(int round);

  int get totalScore {
    int total = 0;
    for (int i = 0; i < numRounds; ++i) total += getScore(i);
    return total;
  }

  /// negative number if left score is winning
  /// 0 if scores are tied
  /// positive number if right score is winning
  int compareScores(int scoreLeft, int scoreRight);

  /// negative number if this player is winning
  /// 0 if players are tied
  /// positive number if this player is losing
  int compareScoreTo(Score other, [int? round = null]) {
    if (round == null) return compareScores(totalScore, other.totalScore);
    assert(round! < numRounds);
    return compareScores(getScore(round!), other.getScore(round!));
  }
}
