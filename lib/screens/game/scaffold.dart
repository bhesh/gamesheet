import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/provider/game.dart';
import 'package:gamesheet/provider/round.dart';
import 'package:gamesheet/provider/score.dart';
import 'package:gamesheet/provider/summary.dart';
import 'package:provider/provider.dart';
import './overview_tab.dart';
import './round_tab.dart';

class GameScaffold extends StatefulWidget {
  final Game game;

  const GameScaffold({
    super.key,
    required this.game,
  });

  @override
  State<GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold>
    with SingleTickerProviderStateMixin {
  List<String>? _roundLabels;
  List<Player>? _players;
  TabController? _tabController;
  List<Player>? _winners;

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameProvider = Provider.of<GameProvider>(context);
    _roundLabels = gameProvider.roundLabels;
    _players = gameProvider.players;
    if (_roundLabels == null || _players == null) {
      gameProvider.initialize();
    } else {
      if (_tabController == null) {
        _tabController = TabController(
          vsync: this,
          length: _roundLabels!.length + 1,
        );
      }
      final scoreProvider = Provider.of<ScoreProvider>(context);
      _winners = scoreProvider.winners;
      if (_winners == null) scoreProvider.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _roundLabels == null || _players == null
        ? _buildLoading(context)
        : _buildTabs(context);
  }

  Widget _buildLoading(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: Text(widget.game.name),
              expandedHeight: 200,
              pinned: true,
              floating: false,
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SafeArea(
          top: false,
          bottom: false,
          child: SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    int numTabs = _roundLabels!.length + 1;
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        var tabBar = TabBar(
          controller: _tabController!,
          isScrollable: true,
          tabs: List.generate(numTabs, (index) {
            if (index == 0) {
              return Tab(
                child: Text(
                  'Overview',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              );
            }
            int round = index - 1;
            final isComplete =
                Provider.of<ScoreProvider>(context).isComplete(round);
            return Tab(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 12,
                ),
                child: Text(
                  '${_roundLabels![round]}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isComplete
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.5)
                          : Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            );
          }),
        );
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: Text(widget.game.name),
              expandedHeight: 200,
              pinned: true,
              floating: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final scoreProvider = Provider.of<ScoreProvider>(context);
                  return constraints.biggest.height < 200
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(
                              top: constraints.biggest.height - 120),
                          child: scoreProvider.buildWinnerWidget(
                            context,
                            Theme.of(context).colorScheme.onPrimary,
                            true,
                          ),
                        );
                },
              ),
              bottom: tabBar,
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TabBarView(
          controller: _tabController!,
          children: List.generate(
            numTabs,
            (index) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      controller: ScrollController(),
                      key: PageStorageKey<int>(index),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        index == 0
                            ? OverviewTab(
                                game: widget.game,
                                players: _players!,
                              )
                            : ChangeNotifierProvider(
                                create: (_) =>
                                    RoundProvider(widget.game, index - 1),
                                child: RoundTab(
                                  game: widget.game,
                                  players: _players!,
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
        ),
      ),
    );
  }
}
