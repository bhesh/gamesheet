import 'package:flutter/material.dart';
import 'package:gamesheet/provider/database.dart';
import 'package:gamesheet/db/settings.dart';

class SettingsProvider {
  static SettingsMap? _settings;

  static Future<SettingsMap> get settings async =>
      _settings != null ? _settings! : await getSettings();

  static Future<SettingsMap> getSettings() async {
    ThemeSelection? themeSelection = null;

    var database = await Provider.settingsDatabase;
    List<Map<String, dynamic>> list = await database.query('settings');
    list.forEach((row) {
      var setting = Setting.fromId(row['id']);
      switch (setting) {
        case Setting.themeSelection:
          themeSelection = ThemeSelection.fromId(row['value']);
      }
    });

    _settings = SettingsMap(themeSelection: themeSelection);

    return _settings!;
  }

  static Future updateSetting(int id, int value) async {
    var database = await Provider.settingsDatabase;
    await database.update(
      'settings',
      {'value': value},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future updateAllSettings(SettingsMap map) async {
    var database = await Provider.settingsDatabase;
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
