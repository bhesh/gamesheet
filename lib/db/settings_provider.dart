import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/settings.dart';
import './database.dart';

class SettingsProvider {
  static SettingsMap? _settings;

  static Future<SettingsMap> get settings async =>
      _settings != null ? _settings! : await getSettings();

  static Future<SettingsMap> getSettings() async {
    Palette? themeColor = null;
    bool? themeIsDark = null;

    var database = await DatabaseProvider.settingsDatabase;
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

    _settings = SettingsMap(
      themeColor: themeColor,
      themeIsDark: themeIsDark,
    );

    return _settings!;
  }

  static Future updateSetting(Setting setting, int value) async {
    var database = await DatabaseProvider.settingsDatabase;
    await database.update(
      'settings',
      {'value': value},
      where: 'id = ?',
      whereArgs: [setting.id],
    );
  }

  static Future updateAllSettings(SettingsMap map) async {
    var database = await DatabaseProvider.settingsDatabase;
    var batch = database.batch();
    map.toMap().forEach(
          (row) => batch.update(
            'settings',
            {'value': row['value']},
            where: 'id = ?',
            whereArgs: [row['id']],
          ),
        );
    await batch.commit(noResult: true);
  }
}
