import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';
import './round_controller.dart';

class RoundTab extends StatelessWidget {
  final List<Player>? players;
  final List<RoundController?>? controllers;
  final bool hasBids;
  final void Function(int)? onScoreChange;
  final String? bidText;
  final String? scoreText;

  const RoundTab({
    this.players,
    this.controllers,
    this.hasBids = false,
    this.onScoreChange,
    this.bidText,
    this.scoreText,
  });

  @override
  Widget build(BuildContext context) {
    // Still loading players
    if (players == null) {
      return SliverList.list(
        children: [
          SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          ),
        ],
      );
    }

    // players != null
    return SliverList.builder(
      itemCount: players!.length,
      itemBuilder: (context, index) {
        // Get player
        assert(index < players!.length); // do not remove
        Player player = players![index];

        //Get controller, if available
        RoundController? roundController = null;
        if (controllers != null) {
          // `players.length == controllers.length` so this implies `index < controllers.length`
          assert(players!.length == controllers!.length);
          roundController = controllers![index];
        }

        // Make children
        List<Widget> children = [
          GamesheetAvatar(
            name: player.name,
            color: player.color,
          ),
          Padding(padding: const EdgeInsets.only(right: 16)),
          Container(
            width: hasBids ? 100 : 186,
            child: Text(
              player.name,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
        ];

        // Add a bid input field if the game has bids
        if (hasBids) {
          children.add(
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 70,
                child: Focus(
                  child: TextField(
                    controller: roundController?.bidController,
                    maxLength: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: bidText ?? 'Bid',
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
                    if (roundController != null && !hasFocus) {
                      roundController!.updateBid().then((changed) {
                        if (onScoreChange != null && changed)
                          onScoreChange!(index);
                      });
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
                controller: roundController?.scoreController,
                maxLength: 4,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: scoreText ?? 'Score',
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
                if (roundController != null && !hasFocus) {
                  roundController!.updateScore().then((changed) {
                    if (onScoreChange != null && changed) onScoreChange!(index);
                  });
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
}
