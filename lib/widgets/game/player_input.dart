import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';

class PlayerInput extends StatelessWidget {
  final Game game;
  final Player player;
  final bool? isDealer;
  final TextEditingController? bidController;
  final void Function()? onBidUnfocus;
  final TextEditingController scoreController;
  final void Function()? onScoreUnfocus;

  const PlayerInput({
    super.key,
    required this.game,
    required this.player,
    this.isDealer,
    this.bidController,
    this.onBidUnfocus,
    required this.scoreController,
    this.onScoreUnfocus,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> children = [
      // Player avatar
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GamesheetAvatar(
            name: player.name,
            color: player.color,
          ),
        ),
      ),

      // Player name
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 72),
          child: Container(
            width: game.hasBids ? size.width - 276 : size.width - 190,
            child: Text(
              player.name,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),

      // Score field
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
          child: _NumberInput(
            labelText: game.scoreText,
            controller: scoreController,
            onUnfocus: onScoreUnfocus,
          ),
        ),
      ),
    ];

    // Bid field
    if (game.hasBids) {
      children.add(
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16, right: 106),
            child: _NumberInput(
              labelText: game.bidText,
              controller: bidController,
              onUnfocus: onBidUnfocus,
            ),
          ),
        ),
      );
    }

    // Make child
    return GamesheetCard(
      padding: EdgeInsets.all(0),
      crossAxisAlignment: CrossAxisAlignment.center,
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isDealer != null && isDealer!
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                width: 8,
              ),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final void Function()? onUnfocus;

  const _NumberInput({
    super.key,
    required this.labelText,
    this.controller,
    this.onUnfocus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      child: Focus(
        child: TextField(
          controller: controller,
          maxLength: 4,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
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
          if (!hasFocus && onUnfocus != null) onUnfocus!();
        },
      ),
    );
  }
}
