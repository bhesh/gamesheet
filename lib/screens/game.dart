import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/db/player.dart';
import 'package:gamesheet/db/round.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/message.dart';
import 'package:gamesheet/widgets/score_keeper.dart';

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
    return ScoreKeeper(
      controller: _tabController,
      title: widget.game.name,
      numTabs: numRounds,
      headerBuilder: (context, index) => Tab(
        child: Container(
          constraints: BoxConstraints(minWidth: 32),
          child: Center(child: Text('${numRounds - index - 1}')),
        ),
      ),
      pageBuilder: (context, round) {
        return SliverList.list(
          children: _players == null
              ? [ScoreboardMessage('Loading...')]
              : [
                  ScoreboardCard(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _players!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            Center(
                              child: Text(
                                _players![index].name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 150,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Score',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),
                  )
                ],
        );
      },
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
