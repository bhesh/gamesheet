import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/db/game.dart';

class GameModel extends ChangeNotifier {
  final Game game;
  List<String>? _roundLabels;
  List<Player>? _players;

  GameModel(this.game) : assert(game.id != null) {
    initialize();
  }

  UnmodifiableListView<String>? get roundLabels =>
      _roundLabels == null ? null : UnmodifiableListView(_roundLabels!);

  int? get numRounds => _roundLabels == null ? null : _roundLabels!.length;

  UnmodifiableListView<Player>? get players =>
      _players == null ? null : UnmodifiableListView(_players!);

  Future<void> initialize() async {
    var players = await GameDatabase.getPlayers(game.id!);
    assert(players.isNotEmpty);
    _roundLabels = game.roundLabels(players.length);
    _players = players;
    notifyListeners();
  }

  Future<void> updatePlayer({
    required int playerId,
    String? name,
    Palette? color,
  }) async {
    if (_players != null) {
      for (int i = 0; i < _players!.length; ++i) {
        if (_players![i].id == playerId) {
          _players![i] = _players![i].copyWith(name: name, color: color);
          await GameDatabase.updatePlayer(_players![i]);
          notifyListeners();
          return;
        }
      }
    }
  }
}
