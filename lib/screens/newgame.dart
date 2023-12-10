import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/dialog.dart';
import 'package:gamesheet/widgets/newgame/rounded_text_field.dart';
import 'package:gamesheet/widgets/newgame/player_input.dart';
import 'package:gamesheet/widgets/newgame/player_text_fields.dart';
import 'package:gamesheet/widgets/newgame/game_type_popup.dart';
import 'package:material_symbols_icons/symbols.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  static final int maxNumPlayers = 16;
  static final int maxNameLength = 40;

  late final TextEditingController _nameController;
  late final List<PlayerController> _playerControllers;

  GameType _selectedGameType = GameType.train;
  String? _nameError;
  String? _playerError;

  @override
  void dispose() {
    _nameController.dispose();
    _playerControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _playerControllers = [PlayerController.random()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Game')),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            GamesheetCard(
              child: RoundedTextField(
                controller: _nameController,
                icon: const Icon(Symbols.videogame_asset),
                hintText: 'Game Name',
                errorText: _nameError,
              ),
            ),
            GamesheetCard(
              title: 'Select game type',
              child: GameTypePopup(
                selected: _selectedGameType,
                onSelected: (gameType) =>
                    setState(() => _selectedGameType = gameType),
              ),
            ),
            GamesheetCard(
              title: 'Players',
              child: PlayerTextFields(
                controllers: _playerControllers,
                maxNumPlayers: maxNumPlayers,
                maxNameLength: maxNameLength,
                hintText: 'Player Name',
                errorText: _playerError,
                onAdd: () => setState(() {
                  _playerError = null;
                  _playerControllers.add(PlayerController.random());
                }),
                onColorChange: (index, color) => setState(
                  () => _playerControllers[index].color = color,
                ),
                onDelete: (index) => setState(() {
                  _playerControllers.removeAt(index).dispose();
                }),
              ),
            ),
            GamesheetCard(
              child: InkWell(
                borderRadius: BorderRadius.circular(29),
                onTap: () => _createGame(context),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        'Create Game',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createGame(BuildContext context) {
    var results = _validateGame();
    if (results != null) {
      var (name, players) = results!;
      loaderDialog(context, () async {
        await GameDatabase.addGame(
          Game(
            name: name,
            type: _selectedGameType,
            created: DateTime.now(),
          ),
          players,
        );
      }).then((_) => Navigator.of(context).pop(true));
    }
  }

  (String, List<(String, Palette)>)? _validateGame() {
    String? name = _validateName();
    List<(String, Palette)>? players = _validatePlayers();
    if (name == null || players == null) {
      setState(() {
        _nameError = name == null ? 'Enter a name for the game' : null;
        _playerError = players == null ? 'Add a player to the game' : null;
      });
      return null;
    }
    return (name!, players!);
  }

  String? _validateName() {
    String name = _nameController.text.trim();
    return name.isEmpty ? null : name;
  }

  List<(String, Palette)>? _validatePlayers() {
    var finalizedPlayers = _playerControllers
        .take(maxNumPlayers)
        .map((player) => (player.text.trim(), player.color))
        .toList();
    finalizedPlayers.removeWhere((item) {
      var (name, _) = item;
      return name.isEmpty;
    });
    return finalizedPlayers.isEmpty ? null : finalizedPlayers;
  }
}
