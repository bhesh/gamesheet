import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/score.dart';

class ScoreRange {
  num minValue;
  num maxValue;

  ScoreRange(this.minValue, this.maxValue);
}

class GameSummary {
  final ScoreRange totalScoreRange;
  final ScoreRange averageScoreRange;

  const GameSummary({
    required this.totalScoreRange,
    required this.averageScoreRange,
  });
}

Future<GameSummary> calculateSummary(Game game, Map<int, Score> scores) async {
  assert(scores.length > 0);
  int initialScore = scores.values.first.totalScore;
  ScoreRange totalScoreRange = ScoreRange(initialScore, initialScore);
  ScoreRange averageScoreRange = ScoreRange(
    initialScore / game.numRounds,
    initialScore / game.numRounds,
  );
  scores.values.forEach((score) {
    final totalScore = score.totalScore;
    if (totalScore < totalScoreRange.minValue)
      totalScoreRange.minValue = totalScore;
    if (totalScore > totalScoreRange.maxValue)
      totalScoreRange.maxValue = totalScore;
    final averageScore = totalScore / game.numRounds;
    if (averageScore < averageScoreRange.minValue)
      averageScoreRange.minValue = averageScore;
    if (averageScore > averageScoreRange.maxValue)
      averageScoreRange.maxValue = averageScore;
  });
  return GameSummary(
    totalScoreRange: totalScoreRange,
    averageScoreRange: averageScoreRange,
  );
}
