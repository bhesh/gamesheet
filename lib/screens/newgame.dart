import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/score.dart';
import 'package:gamesheet/controllers/player_controller.dart';
import 'package:gamesheet/models/game_list.dart';
import 'package:gamesheet/widgets/dialog.dart';
import 'package:gamesheet/widgets/newgame/custom_card.dart';
import 'package:gamesheet/widgets/newgame/dealer_card.dart';
import 'package:gamesheet/widgets/newgame/game_type_card.dart';
import 'package:gamesheet/widgets/newgame/name_card.dart';
import 'package:gamesheet/widgets/newgame/players_card.dart';
import 'package:gamesheet/widgets/newgame/submit_card.dart';
import 'package:provider/provider.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  static final int maxNumPlayers = 16;
  static final int maxNameLength = 40;
  static final int maxNumRounds = 25;

  late final TextEditingController _nameController;
  late final List<PlayerController> _playerControllers;
  late final TextEditingController _roundController;

  // All games
  String _gameName = '';
  GameType _selectedGameType = GameType.train;
  List<(String, Palette)> _players = List.empty();

  // Custom-only stuff
  int _numRounds = 0;
  Scoring _selectedScoring = Scoring.lowest;

  // Dealer stuff
  bool _hasDealer = false;
  int _selectedDealer = 0;

  // Validation errors
  String? _nameError = null;
  String? _playerError = null;
  String? _roundError = null;

  @override
  void dispose() {
    _nameController.dispose();
    _playerControllers.forEach((controller) => controller.dispose());
    _roundController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _playerControllers = [
      PlayerController.random(
        onUnfocus: () => setState(() {
          _players = _getPlayerList();
        }),
      ),
    ];
    _roundController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Always shown children: Name, GameType, and Players
    List<Widget> children = <Widget>[
      NameCard(
        controller: _nameController,
        errorText: _nameError,
      ),
      GameTypeCard(
        selected: _selectedGameType,
        onSelected: (gameType) => setState(() {
          if (gameType == GameType.ping || gameType == GameType.wizard)
            _hasDealer = true;
          else
            _hasDealer = false;
          _selectedGameType = gameType;
        }),
      ),
      PlayersCard(
        controllers: _playerControllers,
        maxNumPlayers: maxNumPlayers,
        maxNameLength: maxNameLength,
        errorText: _playerError,
        onAdd: () => setState(() {
          _playerError = null;
          _playerControllers.add(PlayerController.random(
            onUnfocus: () => setState(() {
              _players = _getPlayerList();
            }),
          ));
        }),
        onColorChange: (index, color) => setState(() {
          _playerControllers[index].color = color;
          _players = _getPlayerList();
        }),
        onDelete: (index) => setState(() {
          _playerControllers.removeAt(index).dispose();
          _selectedDealer = 0;
          _players = _getPlayerList();
        }),
      ),
    ];

    // Custom
    if (_selectedGameType == GameType.custom) {
      children.add(CustomCard(
        roundController: _roundController,
        hasDealer: _hasDealer,
        onDealerChange: (value) => setState(() => _hasDealer = value),
        selectedScoring: _selectedScoring,
        onScoringChange: (scoring) => setState(() {
          _selectedScoring = scoring;
        }),
        roundErrorText: _roundError,
      ));
    }

    // Dealer
    if (_hasDealer && _players.isNotEmpty) {
      children.add(DealerCard(
        players: _players,
        selected: _selectedDealer,
        onSelected: (index) => setState(() => _selectedDealer = index),
      ));
    }

    // Submit button
    children.add(SubmitCard(
      onTap: () => _createGame(context),
    ));

    // Create Scaffold
    return Scaffold(
      appBar: AppBar(title: Text('New Game')),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: children,
        ),
      ),
    );
  }

  void _createGame(BuildContext context) {
    final gameList = Provider.of<GameListModel>(context, listen: false);
    if (_validateGame()) {
      loaderDialog(context, () async {
        switch (_selectedGameType) {
          case GameType.train:
            await gameList.createGame(
              Game.train(
                name: _gameName,
                numPlayers: _players.length,
              ),
              _players,
            );
          case GameType.ping:
            await gameList.createGame(
              Game.ping(
                name: _gameName,
                numPlayers: _players.length,
                dealer: _selectedDealer,
              ),
              _players,
            );
          case GameType.wizard:
            await gameList.createGame(
              Game.wizard(
                name: _gameName,
                numPlayers: _players.length,
                dealer: _selectedDealer,
              ),
              _players,
            );
          case GameType.custom:
            await gameList.createGame(
              Game.custom(
                name: _gameName,
                numPlayers: _players.length,
                numRounds: _numRounds,
                scoring: _selectedScoring,
                dealer: _hasDealer ? _selectedDealer : -1,
              ),
              _players,
            );
        }
      }).then((_) => Navigator.of(context).pop());
    }
  }

  String _getGameName() {
    return _nameController.text.trim();
  }

  List<(String, Palette)> _getPlayerList() {
    return _playerControllers
        .where((player) => player.name != null)
        .take(maxNumPlayers)
        .map((player) => (player.name!, player.color))
        .toList();
  }

  int _getNumRounds() {
    String roundsText = _roundController.text.trim();
    return roundsText.isEmpty ? 0 : int.parse(roundsText);
  }

  bool _validateGame() {
    // Required stuff
    _gameName = _getGameName();
    _players = _getPlayerList();
    if (_selectedGameType == GameType.custom) _numRounds = _getNumRounds();

    // Check for error
    bool hasError = false;
    if (_gameName.isEmpty) {
      _nameError = 'Enter a name for the game';
      hasError = true;
    } else {
      _nameError = null;
    }
    if (_players.isEmpty) {
      _playerError = 'Add a player to the game';
      hasError = true;
    } else {
      _playerError = null;
    }
    if (_selectedGameType == GameType.custom) {
      if (_numRounds < 1) {
        _roundError = 'Too few rounds';
        hasError = true;
      } else if (_numRounds > maxNumRounds) {
        _roundError = 'Too many rounds';
        hasError = true;
      } else {
        _roundError = null;
      }
    }
    setState(() {});
    if (hasError) return false;
    return true;
  }
}
