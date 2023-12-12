import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/app.dart';
import 'package:gamesheet/db/game.dart';

class GameListModel extends ChangeNotifier {
  List<Game>? _games;

  GameListModel() : super() {
    _fetchGames();
  }

  UnmodifiableListView<Game>? get games =>
      _games == null ? null : UnmodifiableListView(_games!);

  Future<void> _fetchGames() async {
    var games = await GameDatabase.getGames();
    _games = UnmodifiableListView(games);
    notifyListeners();
  }

  Future<void> createGame(
    Game game,
    List<(String, Palette)> players,
  ) async {
    await GameDatabase.addGame(game, players);
    await _fetchGames();
  }

  Future<void> removeGame(int gameId) async {
    await GameDatabase.removeGame(gameId);
    await _fetchGames();
  }

  Future<void> removeAllGames() async {
    var database = await AppDatabase.gameDatabase;
    await AppDatabase.createGameDatabase(database);
    await _fetchGames();
  }
}
