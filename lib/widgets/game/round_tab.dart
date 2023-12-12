import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/models/game.dart';
import 'package:gamesheet/models/round.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/game/update_player.dart';
import 'package:provider/provider.dart';
import './player_input.dart';

class RoundTab extends StatefulWidget {
  final Game game;
  final int index;

  const RoundTab({
    super.key,
    required this.game,
    required this.index,
  });

  @override
  State<RoundTab> createState() => _RoundTabState();
}

class _RoundTabState extends State<RoundTab> {
  late final List<TextEditingController>? _bidControllers;
  late final List<TextEditingController> _scoreControllers;

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
        ? List.generate(widget.game.numPlayers, (_) => TextEditingController())
        : null;
    _scoreControllers = List.generate(
      widget.game.numPlayers,
      (_) => TextEditingController(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameModel = Provider.of<GameModel>(context);
    final roundModel = Provider.of<RoundModel>(context);
    if (gameModel.players != null && roundModel.round != null) {
      // Initialize the text fields
      for (int i = 0; i < gameModel.players!.length; ++i) {
        Player player = gameModel.players![i];
        assert(player.id != null);
        Round? round = roundModel.round![player.id!];
        int? bid = round?.bid;
        int? score = round?.score;
        if (_bidControllers != null && bid != null)
          _bidControllers![i].text = '$bid';
        if (score != null) _scoreControllers[i].text = '$score';
      }
      _checkIfComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameModel = Provider.of<GameModel>(context);
    final roundModel = Provider.of<RoundModel>(context);

    // Loading players still
    if (gameModel.players == null)
      return SliverList.list(
        children: <Widget>[
          SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          ),
        ],
      );

    int? dealerIndex = widget.game.dealer == null
        ? null
        : (widget.game.dealer! + widget.index) % gameModel.players!.length;
    return SliverList.builder(
      itemCount: gameModel.players!.length,
      itemBuilder: (context, index) {
        Player player = gameModel.players![index];

        return PlayerInput(
          game: widget.game,
          player: player,
          isDealer: dealerIndex == null ? null : dealerIndex! == index,
          onTap: () => updatePlayerScreen(context, widget.game, player),
          bidController: _bidControllers?[index],
          onBidUnfocus: () {
            String bidText = _bidControllers![index].text.trim();
            int? bid = bidText.isEmpty ? null : int.parse(bidText);
            Player player = gameModel.players![index];
            assert(player.id != null);
            Round? newRound = roundModel.updateBid(player.id!, bid);
            if (newRound != null) {
              gameModel.updateScore(newRound!);
              _checkIfComplete();
            }
          },
          scoreController: _scoreControllers[index],
          onScoreUnfocus: () {
            String scoreText = _scoreControllers[index].text.trim();
            int? score = scoreText.isEmpty ? null : int.parse(scoreText);
            Player player = gameModel.players![index];
            assert(player.id != null);
            Round? newRound = roundModel.updateScore(player.id!, score);
            if (newRound != null) {
              gameModel.updateScore(newRound!);
              _checkIfComplete();
            }
          },
        );
      },
    );
  }

  Future<void> _checkIfComplete() async {
    final gameModel = Provider.of<GameModel>(context, listen: false);
    bool isComplete = true;
    if (widget.game.hasBids && _bidControllers != null)
      _bidControllers.forEach((controller) =>
          isComplete = isComplete && controller.text.isNotEmpty);
    _scoreControllers.forEach(
        (controller) => isComplete = isComplete && controller.text.isNotEmpty);
    if (gameModel.isRoundComplete(widget.index) != isComplete) {
      gameModel.completeRound(widget.index, isComplete);
    }
  }
}
