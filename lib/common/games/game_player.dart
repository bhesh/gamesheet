import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';

abstract class GamePlayer {
  final Player player;
  final int numRounds;

  GamePlayer(this.player, this.numRounds);

  int? get id => player.id;

  String get name => player.name;

  Palette get color => player.color;

  int get gameId => player.gameId;

  void setRound(Round round);

  int getScore(int round);

  int get totalScore {
    int total = 0;
    for (int i = 0; i < numRounds; ++i) total += getScore(i);
    return total;
  }

  /// negative number if this player is winning
  /// 0 if players are tied
  /// positive number if this player is losing
  int compareScores(int scoreLeft, int scoreRight);

  int compareTotalTo(GamePlayer other) =>
      compareScores(totalScore, other.totalScore);
}
