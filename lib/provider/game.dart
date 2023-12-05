import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game.dart';

class GameProvider extends ChangeNotifier {
  List<Game>? _games;

  UnmodifiableListView<Game>? get games =>
      _games == null ? null : UnmodifiableListView(_games!);

  void fetchGames() {
    GameDatabase.getGames().then((games) {
      _games = games;
      notifyListeners();
    });
  }

  void createGame(Game game, List<(String, Palette)> players) {
    GameDatabase.addGame(game, players).then((_) => fetchGames());
  }

  void removeGame(int gameId) {
    GameDatabase.removeGame(gameId).then((_) => fetchGames());
  }
}
