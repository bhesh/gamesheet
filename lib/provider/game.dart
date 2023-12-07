import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/db/game.dart';

class GameProvider extends ChangeNotifier {
  final Game game;
  List<String>? _roundLabels;
  List<Player>? _players;

  GameProvider(this.game) : assert(game.id != null);

  UnmodifiableListView<String>? get roundLabels =>
      _roundLabels == null ? null : UnmodifiableListView(_roundLabels!);

  UnmodifiableListView<Player>? get players =>
      _players == null ? null : UnmodifiableListView(_players!);

  void initialize() {
    GameDatabase.getPlayers(game.id!).then((players) {
      assert(players.isNotEmpty);
      _roundLabels = game.roundLabels(players.length);
      _players = players;
      notifyListeners();
    });
  }

  void updatePlayer(Player player) {
    GameDatabase.updatePlayer(player).then((_) => initialize());
  }
}
