import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/model/round.dart';
import 'package:provider/provider.dart';
import './overview_tab.dart';
import './round_tab.dart';

class GameTabBarView extends StatefulWidget {
  final Game game;
  final int numPlayers;
  final List<String> roundLabels;
  final TabController controller;

  const GameTabBarView({
    super.key,
    required this.game,
    required this.numPlayers,
    required this.roundLabels,
    required this.controller,
  });

  @override
  State<GameTabBarView> createState() => _GameTabBarViewState();
}

class _GameTabBarViewState extends State<GameTabBarView> {
  late final List<ScrollController> _scrollControllers;

  @override
  void dispose() {
    _scrollControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollControllers = List.generate(
      widget.roundLabels.length + 1,
      (_) => ScrollController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      children: List.generate(
        widget.roundLabels.length + 1,
        (index) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Builder(
              builder: (context) {
                return CustomScrollView(
                  controller: _scrollControllers[index],
                  key: PageStorageKey<int>(index),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                    index == 0
                        ? OverviewTab(
                            game: widget.game,
                            numPlayers: widget.numPlayers,
                            roundLabels: widget.roundLabels,
                          )
                        : ChangeNotifierProvider(
                            create: (_) => RoundModel(widget.game, index - 1),
                            child: RoundTab(
                              game: widget.game,
                              numPlayers: widget.numPlayers,
                              roundLabels: widget.roundLabels,
                              index: index - 1,
                            ),
                          ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
