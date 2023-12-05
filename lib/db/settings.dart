import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/settings.dart';
import './app.dart';

class SettingsDatabase {
  static Future<SettingsMap> getSettings() async {
    Palette? themeColor = null;
    bool? themeIsDark = null;

    var database = await AppDatabase.settingsDatabase;
    List<Map<String, dynamic>> list = await database.query('settings');
    list.forEach((row) {
      var setting = Setting.fromId(row['id']);
      switch (setting) {
        case Setting.themeColor:
          themeColor = Palette.fromId(row['value']);
        case Setting.themeIsDark:
          themeIsDark = row['value'] != 0;
      }
    });
    return SettingsMap(
      themeColor: themeColor,
      themeIsDark: themeIsDark,
    );
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
    map.toMap().forEach(
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
