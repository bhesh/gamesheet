import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/models/game.dart';
import 'package:provider/provider.dart';
import './winner_list.dart';

class GameAppBar extends StatelessWidget {
  final Game game;
  final TabController controller;

  const GameAppBar({super.key, required this.game, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Build the AppBar
    return SliverAppBar(
      title: Text(game.name),
      expandedHeight: 200,
      pinned: true,
      floating: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final gameModel = Provider.of<GameModel>(context);
          return constraints.biggest.height < 200
              ? Container()
              : Padding(
                padding: EdgeInsets.only(top: constraints.biggest.height - 120),
                child: GestureDetector(
                  onTap: () {
                    // Go to next incomplete tab
                    if (controller.index == 0) {
                      final gameModel = Provider.of<GameModel>(context, listen: false);
                      for (int i = 0; i < game.numRounds; ++i) {
                        if (!gameModel.isRoundComplete(i)) {
                          controller.animateTo(i + 1);
                        }
                      }
                    }
                    // Go to summary
                    else {
                      controller.animateTo(0);
                    }
                  },
                  child: WinnerList(
                    winners: gameModel.winners,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    border: true,
                  ),
                ),
              );
        },
      ),
      bottom: TabBar(
        controller: controller,
        isScrollable: true,
        tabs: List.generate(game.numRounds + 1, (index) {
          return index == 0
              ? const _Tab(label: 'Overview')
              : _Tab(round: index - 1, label: game.roundLabels[index - 1]);
        }),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final int? round;
  final String label;

  const _Tab({super.key, this.round, required this.label});

  @override
  Widget build(BuildContext context) {
    final gameModel = Provider.of<GameModel>(context);
    final isComplete =
        round == null ? false : gameModel.isRoundComplete(round!);
    return Tab(
      child: Container(
        constraints: BoxConstraints(minWidth: 12),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color:
                isComplete
                    ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
