import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import 'package:sqflite/sqflite.dart';
import './app.dart';

class GameDatabase {
  // games
  static Future<List<Game>> getGames() async {
    var database = await AppDatabase.gameDatabase;
    var list = await database.query('games');
    return list.map((map) => Game.fromMap(map)).toList();
  }

  static Future<int> addGame(
    final Game game,
    final List<(String, Palette)> players,
  ) async {
    final database = await AppDatabase.gameDatabase;
    final gameId = await database.insert('games', game.toMap());
    final batch = database.batch();
    for (int i = 0; i < players.length; ++i) {
      var (name, color) = players[i];
      batch.insert(
        'players',
        Player(
          id: i,
          name: name,
          color: color,
          gameId: gameId,
        ).toMap(),
      );
    }
    batch.commit(noResult: true);
    return gameId;
  }

  static Future removeGame(final int gameId) async {
    var database = await AppDatabase.gameDatabase;
    var batch = database.batch();
    batch.delete('rounds', where: 'gameId = ?', whereArgs: [gameId]);
    batch.delete('players', where: 'gameId = ?', whereArgs: [gameId]);
    batch.delete('games', where: 'id = ?', whereArgs: [gameId]);
    await batch.commit(noResult: true);
  }

  // players
  static Future<List<Player>> getPlayers([final int? gameId = null]) async {
    var database = await AppDatabase.gameDatabase;
    var list = gameId == null
        ? await database.query('players')
        : await database.query(
            'players',
            where: 'gameId = ?',
            whereArgs: [gameId!],
          );
    return list.map((map) => Player.fromMap(map)).toList();
  }

  static Future updatePlayer(final Player player) async {
    assert(player.id != null);
    var database = await AppDatabase.gameDatabase;
    await database.update(
      'players',
      {'name': player.name, 'color': player.color.id},
      where: 'id = ?',
      whereArgs: [player.id!],
    );
  }

  // rounds
  static Future<List<Round>> getRounds([final int? gameId = null]) async {
    var database = await AppDatabase.gameDatabase;
    var list = gameId == null
        ? await database.query('rounds')
        : await database.query(
            'rounds',
            where: 'gameId = ?',
            whereArgs: [gameId!],
          );
    return list.map((map) => Round.fromMap(map)).toList();
  }

  static Future<List<Round>> getRound(
    final int gameId,
    final int round,
  ) async {
    var database = await AppDatabase.gameDatabase;
    var list = await database.query(
      'rounds',
      where: 'gameId = ? AND round = ?',
      whereArgs: [gameId, round],
    );
    return list.map((map) => Round.fromMap(map)).toList();
  }

  static Future updateRound(final Round round) async {
    var database = await AppDatabase.gameDatabase;
    await database.insert('rounds', round.toMap());
  }
}
