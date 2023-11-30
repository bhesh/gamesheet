import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:flutter/services.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/db/player.dart';
import 'package:gamesheet/db/round.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/score_keeper.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen(this.game, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final bool hasBets;
  late final List<String> _roundLabels;
  late final TabController _tabController;
  late final List<Player>? _players;
  late final List<AvatarColors>? _colors;

  bool initialized = false;
  List<List<Round>>? _rounds;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialized
          ? _buildInner(context)
          : SpinKitRing(
              color: Theme.of(context).colorScheme.primary,
              size: 50,
            ),
    );
  }

  Widget _buildInner(BuildContext context) {
    return ScoreKeeper(
      controller: _tabController,
      title: widget.game.name,
      numTabs: _roundLabels.length,
      headerBuilder: (context, index) => Tab(
        child: Container(
          constraints: BoxConstraints(minWidth: 32),
          child: Center(child: Text(_roundLabels[index])),
        ),
      ),
      pageBuilder: (context, page) => _buildPage(context, page),
    );
  }

  Widget _buildPage(BuildContext context, int page) {
    return SliverList.builder(
      itemCount: _players == null ? 1 : _players!.length,
      itemBuilder: (context, index) {
        List<Widget> children = [
          GamesheetAvatar(
            name: _players![index].name,
            color: _colors == null ? null : _colors![index],
          ),
          Padding(padding: EdgeInsets.only(right: 16)),
          Container(
            width: hasBets ? 100 : 186,
            child: Text(
              _players![index].name,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
        ];
        if (hasBets) {
          children.add(
            Container(
              width: 70,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bet',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          );
          children.add(Padding(padding: EdgeInsets.only(right: 16)));
        }
        children.add(
          Container(
            width: 70,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Score',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        );
        return GamesheetCard(
          crossAxisAlignment: CrossAxisAlignment.center,
          child: Row(children: children),
        );
      },
    );
  }

  void _initialize() {
    if (widget.game.id != null) {
      GameProvider.getPlayers(widget.game.id!).then(
        (players) => setState(() {
          hasBets = widget.game.type == GameType.wizard;
          switch (widget.game.type) {
            case GameType.train:
              _roundLabels = List.generate(13, (index) => '${13 - index - 1}');
            case GameType.ping:
              _roundLabels = [
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
                'J',
                'Q',
                'K',
              ];
            case GameType.wizard:
              _roundLabels =
                  List.generate(60 ~/ players.length, (index) => '$index');
          }
          _tabController =
              TabController(length: _roundLabels.length, vsync: this);
          _colors = List.generate(players.length, (_) => AvatarColors.random);
          _players = players;
          initialized = true;
        }),
      );
    }
  }
}
