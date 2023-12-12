import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/score.dart';
import 'package:gamesheet/models/summary.dart';
import 'package:gamesheet/widgets/bar_graph.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/dialog.dart';
import 'package:gamesheet/widgets/rounded_button.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  final Game game;
  final Player player;
  final Map<int, Score> scores;
  final void Function(String, Palette)? onSave;

  const PlayerScreen({
    super.key,
    required this.game,
    required this.player,
    required this.scores,
    this.onSave,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final TextEditingController _nameController;
  late final int _initialColor;
  late String _name;
  late Palette _color;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initialColor = Random().nextInt(Palette.values.length);
    _nameController = TextEditingController();
    _color = widget.player.color;
    _name = widget.player.name;
    _nameController.text = _name;
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.player.id != null);
    Score? score = widget.scores[widget.player.id!];
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: FutureProvider<ScoreRange?>.value(
          initialData: null,
          value: calculatePlayerSummary(widget.game, score),
          builder: (context, _) {
            ScoreRange? scoreRange = Provider.of<ScoreRange?>(context);
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                GamesheetCard(
                  title: 'Player',
                  child: RoundedTextField(
                    controller: _nameController,
                    maxLength: Game.maxNameLength,
                    hintText: 'Player name',
                    errorText: _nameError,
                    icon: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => colorChooserDialog(
                        context,
                        (color) => setState(() => _color = color),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _color.background,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Symbols.save),
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: 'Save',
                      onPressed: () => setState(() {
                        String newName = _nameController.text.trim();
                        if (newName.isEmpty) {
                          _nameError = 'Enter a valid name';
                        } else if (widget.onSave != null) {
                          _name = newName;
                          widget.onSave!(_name, _color);
                        }
                      }),
                    ),
                  ),
                ),
                GamesheetCard(
                  title: 'Round Scores',
                  child: BarGraph.player(
                    game: widget.game,
                    score: score,
                    minValue: scoreRange?.minValue,
                    maxValue: scoreRange?.maxValue,
                    initialColor: _initialColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
