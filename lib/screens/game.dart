import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/model/game.dart';
import 'package:gamesheet/model/score.dart';
import 'package:gamesheet/widgets/game/appbar.dart';
import 'package:gamesheet/widgets/game/tab_bar_view.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameModel(game),
      builder: (context, _) {
        final gameModel = Provider.of<GameModel>(context);
        final game = gameModel.game;
        return gameModel.players == null
            ? Scaffold(
                appBar: AppBar(title: Text(game.name)),
                body: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SpinKitRing(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                ),
              )
            : _GameScaffold(
                game: game,
                numPlayers: gameModel.players!.length,
                roundLabels: gameModel.roundLabels!,
              );
      },
    );
  }
}

class _GameScaffold extends StatefulWidget {
  final Game game;
  final int numPlayers;
  final List<String> roundLabels;

  const _GameScaffold({
    super.key,
    required this.game,
    required this.numPlayers,
    required this.roundLabels,
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
      length: widget.roundLabels.length + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameModel = Provider.of<GameModel>(context);
    assert(gameModel.players != null);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => ScoreModel(widget.game, gameModel.players!),
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: GameAppBar(
                  game: widget.game,
                  numPlayers: widget.numPlayers,
                  roundLabels: widget.roundLabels,
                  controller: _tabController,
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GameTabBarView(
              game: widget.game,
              numPlayers: widget.numPlayers,
              roundLabels: widget.roundLabels,
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}
