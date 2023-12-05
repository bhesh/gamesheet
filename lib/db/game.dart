import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/player.dart';
import 'package:gamesheet/common/round.dart';
import './database.dart';

class GameDatabase {
  static Future<List<Game>> getGames() async {
    var database = await AppDatabase.gameDatabase;
    var list = await database.query('games');
    return list.map((map) => Game.fromMap(map)).toList();
  }

  static Future<List<Player>> getPlayers(int gameId) async {
    var database = await AppDatabase.gameDatabase;
    var list = await database.query(
      'players',
      where: 'gameId = ?',
      whereArgs: [gameId],
    );
    return list.map((map) => Player.fromMap(map)).toList();
  }

  static Future<List<Round>> getRound(int gameId, int round) async {
    var database = await AppDatabase.gameDatabase;
    var list = await database.query(
      'rounds',
      where: 'gameId = ? AND round = ?',
      whereArgs: [gameId, round],
    );
    return list.map((map) => Round.fromMap(map)).toList();
  }

  static Future<List<Round>> getAllRounds(int gameId) async {
    var database = await AppDatabase.gameDatabase;
    var list = await database.query(
      'rounds',
      where: 'gameId = ?',
      whereArgs: [gameId],
    );
    return list.map((map) => Round.fromMap(map)).toList();
  }

  static Future<int> addGame(
    Game game,
    List<(String, Palette)> players,
  ) async {
    var database = await AppDatabase.gameDatabase;
    int gameId = await database.insert('games', game.toMap());
    var batch = database.batch();
    players.forEach((item) {
      var (name, color) = item;
      batch.insert(
        'players',
        Player(name: name, color: color, gameId: gameId).toMap(),
      );
    });
    List<dynamic> results = await batch.commit();
    batch = database.batch();
    results.forEach((playerId) {
      for (int i = 0; i < game.numRounds(players.length); ++i)
        batch.insert(
          'rounds',
          Round(
            gameId: gameId,
            playerId: playerId,
            round: i,
          ).toMap(),
        );
    });
    await batch.commit();
    return gameId;
  }

  static Future updateRound(Round round) async {
    var database = await AppDatabase.gameDatabase;
    var map = round.toMap();
    if (map.containsKey('id')) {
      await database.update(
        'rounds',
        map,
        where: 'id = ?',
        whereArgs: [map['id']],
      );
    } else {
      await database.insert('rounds', map);
    }
  }

  static Future removeGame(int gameId) async {
    var database = await AppDatabase.gameDatabase;
    var batch = database.batch();
    batch.delete('rounds', where: 'gameId = ?', whereArgs: [gameId]);
    batch.delete('players', where: 'gameId = ?', whereArgs: [gameId]);
    batch.delete('games', where: 'id = ?', whereArgs: [gameId]);
    await batch.commit(noResult: true);
  }
}
