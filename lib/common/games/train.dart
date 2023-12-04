import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import './game_player.dart';

class TrainPlayer extends GamePlayer {
  final List<int> scores;

  TrainPlayer(Player player, int numRounds)
      : scores = List.generate(numRounds, (_) => 0),
        super(player, numRounds);

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
