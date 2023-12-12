import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/models/game.dart';
import 'package:gamesheet/widgets/game/appbar.dart';
import 'package:gamesheet/widgets/game/tab_bar_view.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return _GameScaffold(game: game);
  }
}

class _GameScaffold extends StatefulWidget {
  final Game game;

  const _GameScaffold({
    super.key,
    required this.game,
  });

  @override
  State<_GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<_GameScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool initialized = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.game.numRounds + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => GameModel(widget.game),
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: GameAppBar(
                  game: widget.game,
                  controller: _tabController,
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GameTabBarView(
              game: widget.game,
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}
