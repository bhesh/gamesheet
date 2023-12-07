import 'package:gamesheet/common/round.dart';
import './score.dart';

class TrainScore extends Score {
  final List<int> scores;

  TrainScore(int numRounds)
      : scores = List.generate(numRounds, (_) => 0),
        super(numRounds);

  @override
  void setRound(Round round) {
    assert(round.round < scores.length);
    scores[round.round] = round.score == -1 ? 0 : round.score;
  }

  @override
  int getScore(int round) {
    assert(round < scores.length);
    int score = scores[round];
    return score;
  }

  @override
  int compareScores(int leftScore, int rightScore) {
    if (leftScore < rightScore) return -1;
    if (leftScore == rightScore) return 0;
    return 1;
  }
}
