import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/score.dart';

class ScoreRange {
  num minValue;
  num maxValue;

  ScoreRange(this.minValue, this.maxValue);
}

class GameSummary {
  final ScoreRange totalScoreRange;
  final ScoreRange highestScoreRange;
  final ScoreRange lowestScoreRange;

  const GameSummary({
    required this.totalScoreRange,
    required this.highestScoreRange,
    required this.lowestScoreRange,
  });
}

Future<GameSummary> calculateGameSummary(
  Game game,
  Map<int, Score> scores,
) async {
  assert(scores.length > 0);
  int initialScore = scores.values.first.totalScore;
  ScoreRange totalScoreRange = ScoreRange(initialScore, initialScore);
  ScoreRange highestScoreRange = ScoreRange(initialScore, initialScore);
  ScoreRange lowestScoreRange = ScoreRange(initialScore, initialScore);
  scores.values.forEach((score) {
    final totalScore = score.totalScore;
    if (totalScore < totalScoreRange.minValue)
      totalScoreRange.minValue = totalScore;
    if (totalScore > totalScoreRange.maxValue)
      totalScoreRange.maxValue = totalScore;
    final highestScore = score.highestScore;
    if (highestScore < highestScoreRange.minValue)
      highestScoreRange.minValue = highestScore;
    if (highestScore > highestScoreRange.maxValue)
      highestScoreRange.maxValue = highestScore;
    final lowestScore = score.lowestScore;
    if (lowestScore < lowestScoreRange.minValue)
      lowestScoreRange.minValue = lowestScore;
    if (lowestScore > lowestScoreRange.maxValue)
      lowestScoreRange.maxValue = lowestScore;
  });
  return GameSummary(
    totalScoreRange: totalScoreRange,
    highestScoreRange: highestScoreRange,
    lowestScoreRange: lowestScoreRange,
  );
}

Future<ScoreRange> calculatePlayerSummary(
  Game game,
  Score? score,
) async {
  if (score != null) {
    int initialScore = score!.getScore(0);
    ScoreRange scoreRange = ScoreRange(initialScore, initialScore);
    for (int i = 0; i < game.numRounds; ++i) {
      final s = score!.getScore(i);
      if (s < scoreRange.minValue) scoreRange.minValue = s;
      if (s > scoreRange.maxValue) scoreRange.maxValue = s;
    }
    return scoreRange;
  }
  return ScoreRange(0, 0);
}
