import 'package:flutter/material.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/loader.dart';
import 'package:gamesheet/widgets/player_text_fields.dart';
import 'package:material_symbols_icons/symbols.dart';

const int maxNumPlayers = 16;

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _playerControllers = [
    TextEditingController()
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Symbols.add_box),
            tooltip: 'Create Game',
            onPressed: () => _createGame(context),
          ),
        ],
        elevation: 1,
        scrolledUnderElevation: 1,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            GamesheetCard(
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Game Name',
                  helperText: 'Enter a name for the game',
                  errorText: _nameError,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                ),
                maxLength: 20,
              ),
            ),
            GamesheetCard(
              title: 'Select game type',
              child: DropdownMenu<GameType>(
                leadingIcon: Icon(_selectedGameType.icon),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                ),
                initialSelection: _selectedGameType,
                onSelected: (GameType? type) {
                  setState(() {
                    _selectedGameType = type!;
                  });
                },
                dropdownMenuEntries: GameType.values
                    .map<DropdownMenuEntry<GameType>>((GameType type) {
                  return DropdownMenuEntry<GameType>(
                    leadingIcon: Icon(type.icon),
                    value: type,
                    label: type.label,
                  );
                }).toList(),
                expandedInsets: EdgeInsets.all(0),
              ),
            ),
            GamesheetCard(
              title: 'Players',
              child: PlayerTextFields(
                controllers: _playerControllers,
                maxNumPlayers: maxNumPlayers,
                maxNameLength: 20,
                labelText: 'Player Name',
                helperText: 'Enter a name for the player',
                errorText: _playerError,
                onAdd: (context) => setState(() {
                  _playerError = null;
                  _playerControllers.add(TextEditingController());
                }),
                onDelete: (context, index) => setState(() {
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
        .map((player) => player.text.trim())
        .toList();
    finalizedPlayers.removeWhere((name) => name.isEmpty);
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
        await GameProvider.addGame(
          Game(name: finalizedName, type: _selectedGameType),
          finalizedPlayers,
        );
      }).then((_) => Navigator.of(context).pop(true));
    }
  }
}
