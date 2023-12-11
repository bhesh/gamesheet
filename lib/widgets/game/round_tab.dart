import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/model/game.dart';
import 'package:gamesheet/model/round.dart';
import 'package:gamesheet/model/score.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:provider/provider.dart';
import './player_input.dart';

class RoundTab extends StatefulWidget {
  final Game game;
  final int numPlayers;
  final List<String> roundLabels;
  final int index;

  const RoundTab({
    super.key,
    required this.game,
    required this.numPlayers,
    required this.roundLabels,
    required this.index,
  });

  @override
  State<RoundTab> createState() => _RoundTabState();
}

class _RoundTabState extends State<RoundTab> {
  late final List<TextEditingController>? _bidControllers;
  late final List<TextEditingController> _scoreControllers;

  late List<Player> _players;
  Map<int, Round>? _round;

  @override
  void dispose() {
    _bidControllers?.forEach((controller) => controller.dispose());
    _scoreControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bidControllers = widget.game.hasBids
        ? List.generate(widget.numPlayers, (_) => TextEditingController())
        : null;
    _scoreControllers = List.generate(
      widget.numPlayers,
      (_) => TextEditingController(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameModel = Provider.of<GameModel>(context);
    assert(gameModel.players != null);
    _players = gameModel.players!;
    final roundModel = Provider.of<RoundModel>(context);
    _round = roundModel.round;
    if (_round != null) {
      // Initialize the text fields
      for (int i = 0; i < _players.length; ++i) {
        Player player = _players[i];
        assert(player.id != null);
        int? bid = _round![player.id!]?.bid;
        int? score = _round![player.id!]?.score;
        if (_bidControllers != null && bid != null && bid! != -1) {
          _bidControllers![i].text = '$bid';
        }
        if (score != null && score! != -1) {
          _scoreControllers[i].text = '$score';
        }
      }
      _checkIfComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get dealer information
    int? dealerIndex = widget.game.dealer < 0
        ? null
        : (widget.game.dealer! + widget.index) % _players.length;

    final roundModel = Provider.of<RoundModel>(context);
    return SliverList.builder(
      itemCount: _players.length,
      itemBuilder: (context, index) {
        Player player = _players[index];

        return PlayerInput(
          game: widget.game,
          player: player,
          isDealer: dealerIndex == null ? null : dealerIndex! == index,
          bidController: _bidControllers?[index],
          onBidUnfocus: () {
            String bidText = _bidControllers![index].text.trim();
            int bid = bidText.isEmpty ? -1 : int.parse(bidText);
            Player player = _players[index];
            assert(player.id != null);
            Round? newRound = roundModel.updateBid(player.id!, bid);
            if (newRound != null) {
              final scoreModel = Provider.of<ScoreModel>(
                context,
                listen: false,
              );
              scoreModel.updateScore(newRound!);
              _checkIfComplete();
            }
          },
          scoreController: _scoreControllers[index],
          onScoreUnfocus: () {
            String scoreText = _scoreControllers[index].text.trim();
            int score = scoreText.isEmpty ? -1 : int.parse(scoreText);
            Player player = _players[index];
            assert(player.id != null);
            Round? newRound = roundModel.updateScore(player.id!, score);
            if (newRound != null) {
              final scoreModel = Provider.of<ScoreModel>(
                context,
                listen: false,
              );
              scoreModel.updateScore(newRound!);
              _checkIfComplete();
            }
          },
        );
      },
    );
  }

  Future<void> _checkIfComplete() async {
    final scoreModel = Provider.of<ScoreModel>(context, listen: false);
    bool isComplete = true;
    if (widget.game.hasBids && _bidControllers != null)
      _bidControllers.forEach((controller) =>
          isComplete = isComplete && controller.text.isNotEmpty);
    _scoreControllers.forEach(
        (controller) => isComplete = isComplete && controller.text.isNotEmpty);
    if (scoreModel.isComplete(widget.index) != isComplete) {
      scoreModel.updateRound(widget.index, isComplete);
    }
  }
}
