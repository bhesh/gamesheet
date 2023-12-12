import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/settings.dart';
import './app.dart';

class SettingsDatabase {
  static Future<SettingsMap> getSettings() async {
    var database = await AppDatabase.settingsDatabase;
    List<Map<String, dynamic>> rows = await database.query('settings');
    return SettingsMap.fromRows(rows);
  }

  static Future updateSetting(Setting setting, int value) async {
    var database = await AppDatabase.settingsDatabase;
    await database.update(
      'settings',
      {'value': value},
      where: 'id = ?',
      whereArgs: [setting.id],
    );
  }

  static Future updateAllSettings(SettingsMap map) async {
    var database = await AppDatabase.settingsDatabase;
    var batch = database.batch();
    map.toRows().forEach(
          (row) => batch.update(
            'settings',
            row,
            where: 'id = ?',
            whereArgs: [row['id']],
          ),
        );
    await batch.commit(noResult: true);
  }
}
