import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/loader.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';
import './creategame/player_controller.dart';
import './creategame/player_text_fields.dart';
import './creategame/game_type_popup.dart';

const int maxNumPlayers = 16;
const int maxNameLength = 40;

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final TextEditingController _nameController = TextEditingController();
  late final List<PlayerController> _playerControllers;

  GameType _selectedGameType = GameType.train;
  String? _nameError;
  String? _playerError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _playerControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _playerControllers = [PlayerController.random()];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Symbols.add_box),
            tooltip: 'Create Game',
            onPressed: () => _createGame(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8),
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
                  () => _playerControllers[index].setColor(color),
                ),
                onDelete: (index) => setState(() {
                  _playerControllers.removeAt(index).dispose();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createGame(BuildContext context) {
    var finalizedName = _nameController.text.trim();
    var finalizedPlayers = _playerControllers
        .take(maxNumPlayers)
        .map((player) => (player.text.trim(), player.color))
        .toList();
    finalizedPlayers.removeWhere((item) {
      var (name, _) = item;
      return name.isEmpty;
    });
    if (finalizedName.isEmpty || finalizedPlayers.isEmpty) {
      setState(() {
        _nameError = finalizedName.isEmpty ? 'Enter a name for the game' : null;
        _playerError =
            finalizedPlayers.isEmpty ? 'Add a player to the game' : null;
      });
    } else {
      setState(() {
        _nameError = null;
        _playerError = null;
      });
      loaderDialog(context, () async {
        await GameDatabase.addGame(
          Game(
            name: finalizedName,
            type: _selectedGameType,
            created: DateTime.now(),
          ),
          finalizedPlayers,
        );
      }).then((_) => Navigator.of(context).pop(true));
    }
  }
}
