import 'package:flutter/material.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/db/game_provider.dart';

class RoundController {
  final TextEditingController bidController;
  final TextEditingController scoreController;
  Round round;

  RoundController(this.round)
      : this.bidController = TextEditingController(),
        this.scoreController = TextEditingController() {
    if (round.bid != -1) bidController.text = '${round.bid}';
    if (round.score != -1) scoreController.text = '${round.score}';
  }

  @override
  void dispose() {
    bidController.dispose();
    scoreController.dispose();
  }

  int? get bid => round.bid;

  Future<bool> updateBid() async {
    var value = bidController.text.trim();
    var newBid = value.isEmpty ? -1 : int.parse(value);
    if (bid != newBid) {
      round = round.copyWith(bid: newBid);
      await GameProvider.updateRound(round);
      return true;
    }
    return false;
  }

  int? get score => round.score;

  Future updateScore() async {
    var value = scoreController.text.trim();
    var newScore = value.isEmpty ? -1 : int.parse(value);
    if (score != newScore) {
      round = round.copyWith(score: newScore);
      await GameProvider.updateRound(round);
      return true;
    }
    return false;
  }
}
