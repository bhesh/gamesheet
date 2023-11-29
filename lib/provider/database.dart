import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const int dbVersion = 1;

DatabaseFactory get databaseFactory => (Platform.isLinux || Platform.isWindows)
    ? databaseFactoryFfi
    : sqflite.databaseFactory;

class AppDatabase {
  static Database? _database;

  static Future initialize() async {
    if (_database == null) {
      sqfliteFfiInit();
      await _initDatabase();
    }
  }

  static Future<Database> get database async =>
      _database == null ? await _initDatabase() : _database!;

  static Future<Database> _initDatabase() async {
    final Directory directory = await getApplicationSupportDirectory();
    final dbPath = join(directory.path, 'database.db');
    print('Database path: $dbPath');
    _database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async => await _createDatabase(db),
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < dbVersion) await _createDatabase(db);
        },
        version: dbVersion,
      ),
    );
    return _database!;
  }

  static Future _createDatabase(Database db) async {
    var batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS games');
    batch.execute(
      '''
      CREATE TABLE games (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          type INTEGER NOT NULL
      )
      ''',
    );
    batch.execute('DROP TABLE IF EXISTS players');
    batch.execute(
      '''
      CREATE TABLE players (
          id INTEGER PRIMARY KEY,
          gameId INTEGER NOT NULL,
          name TEXT NOT NULL
      )
      ''',
    );
    batch.execute('DROP TABLE IF EXISTS rounds');
    batch.execute(
      '''
      CREATE TABLE rounds (
          id INTEGER PRIMARY KEY,
          gameId INTEGER NOT NULL,
          playerId INTEGER NOT NULL,
          round INTEGER NOT NULL,
          bet INTEGER,
          score INTEGER
      )
      ''',
    );
    await batch.commit(noResult: true);
  }
}
