import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/provider/round.dart';
import 'package:gamesheet/provider/score.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:provider/provider.dart';

class RoundTab extends StatefulWidget {
  final Game game;
  final List<Player> players;
  final int index;

  const RoundTab({
    super.key,
    required this.game,
    required this.players,
    required this.index,
  });

  @override
  State<RoundTab> createState() => _RoundTabState();
}

class _RoundTabState extends State<RoundTab> {
  Map<int, Round>? _round;
  bool _isComplete = false;

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
        ? List.generate(widget.players.length, (_) => TextEditingController())
        : null;
    _scoreControllers = List.generate(
      widget.players.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final roundProvider = Provider.of<RoundProvider>(context);
    _round = roundProvider.round;
    if (_round == null) {
      roundProvider.initialize();
    } else {
      // Initialize the text fields
      for (int i = 0; i < widget.players.length; ++i) {
        Player player = widget.players[i];
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
    final roundProvider = Provider.of<RoundProvider>(context);
    return SliverList.builder(
      itemCount: widget.players.length,
      itemBuilder: (context, index) {
        assert(index < widget.players.length);
        Player player = widget.players[index];

        // Add the player avatar and name
        List<Widget> children = [
          GamesheetAvatar(
            name: player.name,
            color: player.color,
          ),
          Padding(padding: const EdgeInsets.only(right: 16)),
          Container(
            width: widget.game.hasBids ? 100 : 186,
            child: Text(
              player.name,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
        ];

        // Add a bid input field if the game has bids
        if (widget.game.hasBids) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 70,
                child: Focus(
                  child: TextField(
                    controller: _bidControllers![index],
                    maxLength: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: widget.game.bidText,
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      String bidText = _bidControllers![index].text.trim();
                      int bid = bidText.isEmpty ? -1 : int.parse(bidText);
                      Player player = widget.players[index];
                      assert(player.id != null);
                      Round? newRound =
                          roundProvider.updateBid(player.id!, bid);
                      if (newRound != null) {
                        final scoreProvider = Provider.of<ScoreProvider>(
                          context,
                          listen: false,
                        );
                        scoreProvider.updateScore(newRound!);
                        _checkIfComplete();
                      }
                    }
                  },
                ),
              ),
            ),
          );
        }

        // Add a score input field
        children.add(
          Container(
            width: 70,
            child: Focus(
              child: TextField(
                controller: _scoreControllers![index],
                maxLength: 4,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.game.scoreText,
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  String scoreText = _scoreControllers[index].text.trim();
                  int score = scoreText.isEmpty ? -1 : int.parse(scoreText);
                  Player player = widget.players[index];
                  assert(player.id != null);
                  Round? newRound =
                      roundProvider.updateScore(player.id!, score);
                  if (newRound != null) {
                    final scoreProvider = Provider.of<ScoreProvider>(
                      context,
                      listen: false,
                    );
                    scoreProvider.updateScore(newRound!);
                    _checkIfComplete();
                  }
                }
              },
            ),
          ),
        );

        // Make child
        return GamesheetCard(
          crossAxisAlignment: CrossAxisAlignment.center,
          child: Row(children: children),
        );
      },
    );
  }

  void _checkIfComplete() {
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
    Future<bool>(() {
      bool isComplete = true;
      if (widget.game.hasBids && _bidControllers != null)
        _bidControllers.forEach((controller) =>
            isComplete = isComplete && controller.text.isNotEmpty);
      _scoreControllers.forEach((controller) =>
          isComplete = isComplete && controller.text.isNotEmpty);
      return isComplete;
    }).then((result) {
      if (_isComplete != result) {
        setState(() => _isComplete = result);
        scoreProvider.updateRound(widget.index, result);
      }
    });
  }
}
