import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:gamesheet/common/games/game_player.dart';
import 'package:gamesheet/common/games/ping.dart';
import 'package:gamesheet/common/games/train.dart';
import 'package:gamesheet/common/games/wizard.dart';
import 'package:gamesheet/db/game.dart';
import './game/overview_tab.dart';
import './game/round_controller.dart';
import './game/round_tab.dart';
import './game/scaffold.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen(this.game, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final bool _hasBids;
  late final List<String> _roundLabels;
  late final TabController _tabController;
  late final List<Player> _players;
  late final List<GamePlayer> _gamePlayers;
  // [round index][player index] = controller
  late final List<List<RoundController?>> _rounds;

  // Easier way to track the state of initialization
  bool _playersInitialized = false;
  bool _roundsInitialized = false;

  @override
  void initState() {
    super.initState();
    // initialize the players and controllers first
    _initializePlayers().then(
      (_) => setState(() {
        _playersInitialized = true;
        // then look for round data
        _initializeRounds().then(
          (_) => setState(() {
            _roundsInitialized = true;
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assert everything
    bool hasBids = false;
    List<String>? roundLabels = null;
    TabController? tabController = null;
    List<Player>? players = null;
    List<List<RoundController?>>? rounds = null;
    if (_playersInitialized) {
      hasBids = _hasBids;
      roundLabels = _roundLabels;
      tabController = _tabController;
      players = _players;
      if (_roundsInitialized) {
        assert(_roundLabels.length == _rounds.length);
        rounds = _rounds;
      }
    }

    return Scaffold(
      body: GameScaffold(
        controller: tabController ?? TabController(length: 1, vsync: this),
        title: widget.game.name,
        numTabs: roundLabels == null ? 1 : roundLabels!.length + 1,
        headerBuilder: (context, page) => Tab(
          child: Container(
            constraints: const BoxConstraints(minWidth: 32),
            child: Center(
              child: Text(
                // if page == 0 => Overview, else roundLabels[page - 1]
                page == 0
                    ? 'Overview'
                    : roundLabels == null
                        ? '...'
                        : roundLabels![page - 1],
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
        pageBuilder: (context, page) {
          // Overview
          if (page == 0) {
            return OverviewTab(
              game: widget.game,
              players: _playersInitialized ? _gamePlayers : null,
            );
          }

          // Overview is 0 so round is `page - 1`
          int round = page - 1;
          List<Player>? players = _playersInitialized ? _players! : null;
          List<RoundController?>? controllers = null;
          bool hasBids = _playersInitialized ? _hasBids! : false;
          if (_roundsInitialized) {
            assert(round < _rounds.length);
            controllers = _rounds[round];
          }
          return RoundTab(
            players: players,
            controllers: controllers,
            hasBids: hasBids,
            onScoreChange: (index) => _updateScore(round, index),
            bidText: widget.game.bidText,
            scoreText: widget.game.scoreText,
          );
        },
      ),
    );
  }

  Future _initializePlayers() async {
    assert(widget.game.id != null);
    List<Player> players = await GameDatabase.getPlayers(widget.game.id!);
    assert(players.length > 0);

    // Initialize everything
    _players = players;
    _hasBids = widget.game.type == GameType.wizard;
    _roundLabels = widget.game.roundLabels(_players.length);
    _tabController = TabController(
      length: _roundLabels.length + 1, // overview + rounds
      vsync: this,
    );
    _rounds = List.generate(
      _roundLabels.length,
      (_) => List.filled(_players.length, null),
    );

    // Make GamePlayers which keeps track of total scores
    switch (widget.game.type) {
      case GameType.train:
        _gamePlayers = List.generate(
          _players.length,
          (index) => TrainPlayer(_players[index], _roundLabels.length),
        );
      case GameType.ping:
        _gamePlayers = List.generate(
          _players.length,
          (index) => PingPlayer(_players[index], _roundLabels.length),
        );
      case GameType.wizard:
        _gamePlayers = List.generate(
          _players.length,
          (index) => WizardPlayer(_players[index], _roundLabels.length),
        );
    }
  }

  Future _initializeRounds() async {
    assert(widget.game.id != null);
    List<Round> rounds = await GameDatabase.getAllRounds(widget.game.id!);
    rounds.forEach((round) {
      assert(round.round < _rounds.length);
      var playerInd = _players.indexWhere((player) {
        assert(player.id != null);
        return player.id! == round.playerId;
      });
      assert(playerInd < _rounds[round.round].length);
      _rounds[round.round][playerInd] = RoundController(round);
      _gamePlayers[playerInd].setRound(round);
    });

    // This should not be needed anymore but leaving it here just in case.
    // It ensures there are no NULL round controllers. This runs async so
    // the performance hit should not be too great.
    for (int i = 0; i < _rounds.length; ++i) {
      for (int j = 0; j < _rounds[i].length; ++j) {
        if (_rounds[i][j] == null) {
          _rounds[i][j] = RoundController(
            Round(
              gameId: widget.game.id!,
              playerId: _players[j].id!,
              round: i,
            ),
          );
        }
      }
    }
  }

  void _updateScore(int round, int playerInd) {
    assert(round < _rounds.length);
    List<RoundController?> roundScores = _rounds[round];
    assert(playerInd < _gamePlayers.length);
    GamePlayer player = _gamePlayers[playerInd];
    assert(roundScores.length == _gamePlayers.length);
    if (roundScores[playerInd] != null) {
      setState(() => player.setRound(roundScores[playerInd]!.round));
    }
  }
}
