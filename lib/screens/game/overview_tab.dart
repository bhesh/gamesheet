import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/games/game_player.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';
import './bar_graph.dart';

class OverviewTab extends StatefulWidget {
  final Game game;
  final List<GamePlayer>? players;

  const OverviewTab({
    super.key,
    required this.game,
    this.players,
  });

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  List<GamePlayer>? _winners;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (widget.players != null && !_initialized)
      _calculateWinners().then((_) => setState(() => _initialized = true));
    return SliverList.builder(
      itemCount: widget.players == null ? 3 : widget.players!.length + 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GamesheetCard(
            title: 'Winning',
            child: Column(
              children: _winners == null
                  ? [Text('No winners')]
                  : _winners!
                      .map((player) => Text(
                            player.name,
                            style: Theme.of(context).textTheme.labelLarge,
                          ))
                      .toList(),
            ),
          );
        }

        if (index == 1) {
          return GamesheetCard(
            title: 'Total Scores',
            child: widget.players == null
                ? SpinKitRing(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  )
                : BarGraph.total(
                    game: widget.game,
                    players: widget.players!,
                  ),
          );
        }

        if (index == 2) {
          return GamesheetCard(
            title: 'Average Scores',
            child: widget.players == null
                ? SpinKitRing(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  )
                : BarGraph.average(
                    game: widget.game,
                    players: widget.players!,
                  ),
          );
        }
      },
    );
  }

  Future _calculateWinners() async {
    assert(widget.players!.isNotEmpty);
    GamePlayer winner = widget.players![0];
    widget.players!.forEach((p) {
      if (p.compareTotalTo(winner) < 0) winner = p;
    });
    print('Winning score: ${winner.totalScore}');
    _winners = widget.players!
        .where((p) => p.totalScore == winner.totalScore)
        .toList();
    if (_winners!.length == widget.players!.length) _winners = null;
  }
}
