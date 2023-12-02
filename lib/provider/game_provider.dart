import 'package:gamesheet/provider/database.dart';
import 'package:gamesheet/db/color.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/db/player.dart';
import 'package:gamesheet/db/round.dart';

class GameProvider {
  static Future<List<Game>> getGames() async {
    var database = await Provider.gameDatabase;
    var list = await database.query('games');
    return list.map((map) => Game.fromMap(map)).toList();
  }

  static Future<List<Player>> getPlayers(int gameId) async {
    var database = await Provider.gameDatabase;
    var list = await database.query(
      'players',
      where: 'gameId = ?',
      whereArgs: [gameId],
    );
    return list.map((map) => Player.fromMap(map)).toList();
  }

  static Future<List<Round>> getRound(int gameId, int round) async {
    var database = await Provider.gameDatabase;
    var list = await database.query(
      'rounds',
      where: 'gameId = ? AND round = ?',
      whereArgs: [gameId, round],
    );
    return list.map((map) => Round.fromMap(map)).toList();
  }

  static Future<int> addGame(
    Game game,
    List<(String, GameColor)> players,
  ) async {
    var database = await Provider.gameDatabase;
    int gameId = await database.insert('games', game.toMap());
    var batch = database.batch();
    players.forEach((item) {
      var (name, color) = item;
      batch.insert(
        'players',
        Player(
          name: name,
          color: color,
          gameId: gameId,
        ).toMap(),
      );
    });
    await batch.commit(noResult: true);
    return gameId;
  }

  static Future<int> removeGame(int gameId) async {
    var database = await Provider.gameDatabase;
    await database.delete(
      'players',
      where: 'gameId = ?',
      whereArgs: [gameId],
    );
    return await database.delete(
      'games',
      where: 'id = ?',
      whereArgs: [gameId],
    );
  }
}
