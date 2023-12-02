import 'package:flutter/material.dart';
import 'package:gamesheet/db/color.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/loader.dart';
import 'package:gamesheet/widgets/player_text_fields.dart';
import 'package:gamesheet/widgets/popup_selector.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';

const int maxNumPlayers = 16;

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
            icon: Icon(Symbols.add_box),
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
                icon: Icon(Symbols.videogame_asset),
                hintText: 'Game Name',
                errorText: _nameError,
              ),
            ),
            GamesheetCard(
              title: 'Select game type',
              child: PopupSelector(
                initialSelection: Row(
                  children: <Widget>[
                    Icon(_selectedGameType.icon),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        _selectedGameType.label,
                        style:
                            Theme.of(context).inputDecorationTheme?.hintStyle,
                      ),
                    ),
                  ],
                ),
                selectionPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                itemPadding: EdgeInsets.symmetric(vertical: 5),
                itemCount: GameType.values.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(GameType.values[index].icon, size: 48),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            GameType.values[index].label,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                ?.hintStyle,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onSelected: (index) => setState(
                  () => _selectedGameType = GameType.values[index],
                ),
              ),
            ),
            GamesheetCard(
              title: 'Players',
              child: PlayerTextFields(
                controllers: _playerControllers,
                maxNumPlayers: maxNumPlayers,
                maxNameLength: 20,
                hintText: 'Player Name',
                errorText: _playerError,
                onAdd: (context) => setState(() {
                  _playerError = null;
                  _playerControllers.add(PlayerController.random());
                }),
                onAvatar: (context, index) => _colorChooser(context, index),
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
        await GameProvider.addGame(
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

  void _colorChooser(BuildContext context, int playerIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 75,
              childAspectRatio: 1.0,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: GameColor.numColors,
            itemBuilder: (context, colorIndex) {
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: GameColor.values[colorIndex].background,
                    borderRadius: BorderRadius.circular(37.5),
                  ),
                ),
                onTap: () {
                  setState(() => _playerControllers[playerIndex].setColor(
                        GameColor.values[colorIndex],
                      ));
                  Navigator.of(context).pop(true);
                },
              );
            },
          ),
        );
      },
    );
  }
}
