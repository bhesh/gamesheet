import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/model/score.dart';
import 'package:provider/provider.dart';
import './winner_list.dart';

class GameAppBar extends StatelessWidget {
  final Game game;
  final int numPlayers;
  final List<String> roundLabels;
  final TabController controller;

  const GameAppBar({
    super.key,
    required this.game,
    required this.numPlayers,
    required this.roundLabels,
    required this.controller,
  });

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
          final scoreModel = Provider.of<ScoreModel>(context);
          return constraints.biggest.height < 200
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(
                    top: constraints.biggest.height - 120,
                  ),
                  child: WinnerList(
                    winners: scoreModel.winners,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    border: true,
                  ),
                );
        },
      ),
      bottom: TabBar(
        controller: controller,
        isScrollable: true,
        tabs: List.generate(roundLabels.length + 1, (index) {
          int round = index - 1;
          if (index == 0)
            return const _Tab(
              label: 'Overview',
            );
          return _Tab(
            round: round,
            label: roundLabels[index - 1],
          );
        }),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final int? round;
  final String label;

  const _Tab({
    super.key,
    this.round,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context);
    final isComplete = round != null ? scoreModel.isComplete(round!) : false;
    return Tab(
      child: Container(
        constraints: BoxConstraints(
          minWidth: 12,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isComplete
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                  : Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
