import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const int dbVersion = 1;

DatabaseFactory get databaseFactory => (Platform.isLinux || Platform.isWindows)
    ? databaseFactoryFfi
    : sqflite.databaseFactory;

class Provider {
  static Database? _settingsDatabase;
  static Database? _gameDatabase;

  static Future initialize() async {
    sqfliteFfiInit();
    if (_settingsDatabase == null) await _initSettingsDatabase();
    if (_gameDatabase == null) await _initGameDatabase();
  }

  static Future<Database> get settingsDatabase async =>
      _settingsDatabase == null
          ? await _initSettingsDatabase()
          : _settingsDatabase!;

  static Future<Database> _initSettingsDatabase() async {
    final Directory directory = await getApplicationSupportDirectory();
    final dbPath = join(directory.path, 'settings.db');
    print('Settings database path: $dbPath');
    _settingsDatabase = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async => await createSettingsDatabase(db),
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < dbVersion) await createSettingsDatabase(db);
        },
        version: dbVersion,
      ),
    );
    return _settingsDatabase!;
  }

  static Future createSettingsDatabase(Database db) async {
    var batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS settings');
    batch.execute(
      '''
      CREATE TABLE settings (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          value INTEGER NOT NULL
      )
      ''',
    );
    await batch.commit(noResult: true);
  }

  static Future<Database> get gameDatabase async =>
      _gameDatabase == null ? await _initGameDatabase() : _gameDatabase!;

  static Future<Database> _initGameDatabase() async {
    final Directory directory = await getApplicationSupportDirectory();
    final dbPath = join(directory.path, 'database.db');
    print('Game database path: $dbPath');
    _gameDatabase = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async => await createGameDatabase(db),
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < dbVersion) await createGameDatabase(db);
        },
        version: dbVersion,
      ),
    );
    return _gameDatabase!;
  }

  static Future createGameDatabase(Database db) async {
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
