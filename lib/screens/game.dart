import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/db/player.dart';
import 'package:gamesheet/db/round.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/message.dart';

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayerScreen(game),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final Game game;

  const PlayerScreen(this.game, {super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  static final int numRounds = 13;
  final List<bool> _panels = List.filled(numRounds, false);
  List<Player>? _players;
  List<List<Round>>? _rounds;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: numRounds, vsync: this);
    _fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(widget.game.name),
              elevation: 1,
              scrolledUnderElevation: 1,
              shadowColor: Theme.of(context).shadowColor,
              expandedHeight: 200,
              pinned: true,
              floating: false,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: List.generate(
                  numRounds,
                  (index) => Tab(
                    child: Text('Round ${numRounds - index - 1}'),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          numRounds,
          (index) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (context) {
                  return CustomScrollView(
                    key: PageStorageKey<int>(index),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverList.list(
                        children: _players == null
                            ? [ScoreboardMessage('Loading...')]
                            : _players!.map((player) {
                                return ScoreboardCard(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: player.name,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                );
                              }).toList(),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  void _fetchPlayers() {
    if (widget.game.id != null) {
      new Future<List<Player>>(() async {
        return await GameProvider.getPlayers(widget.game.id!);
      }).then(
        (players) => setState(() {
          _players = players;
        }),
      );
    }
  }

  String _getData(int index) {
    if (_players == null) {
      return '';
    }
    return (index % (numRounds + 1) == 0)
        ? _players![index ~/ (numRounds + 1)].name
        : '0';
  }
}
