import 'package:gamesheet/common/round.dart';
import './score.dart';

class WizardScore extends Score {
  final List<int> scores;

  WizardScore(int numRounds)
      : scores = List.generate(numRounds, (_) => 0),
        super(numRounds);

  @override
  void setRound(Round round) {
    assert(round.round < scores.length);
    if (round.bid == -1 || round.score == -1) {
      scores[round.round] = 0;
    } else if (round.bid == round.score) {
      scores[round.round] = (round.bid + 2) * 10;
    } else {
      scores[round.round] = (round.bid - round.score).abs() * -10;
    }
  }

  @override
  int getScore(int round) {
    assert(round < scores.length);
    int score = scores[round];
    return score;
  }

  @override
  int compareScores(int leftScore, int rightScore) {
    if (leftScore < rightScore) return 1;
    if (leftScore == rightScore) return 0;
    return -1;
  }
}
