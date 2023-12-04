import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/settings.dart';
import 'package:gamesheet/common/themes.dart';
import 'package:gamesheet/db/database.dart';
import 'package:gamesheet/db/settings_provider.dart';
import 'package:gamesheet/widgets/loader.dart';
import 'package:provider/provider.dart';
import './settings/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SettingsSection(
            header: 'Look and feel',
            children: <Widget>[
              SettingsField(
                title: 'Theme',
                // Hana for my wife
                description: theme.color == Palette.lightPink && theme.isDark
                    ? 'Hana'
                    : (theme.isDark ? 'Dark ' : 'Light ') + theme.color.label,
                onTap: () => _changeTheme(theme),
              ),
            ],
          ),
          const Divider(),
          const SettingsSection(
            header: 'General',
            children: <Widget>[
              const SettingsField(
                title: 'About',
                description: 'Score tracker for a variety of games',
              ),
            ],
          ),
          const Divider(),
          SettingsSection(
            header: 'Danger',
            headerStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error),
            children: <Widget>[
              SettingsField(
                title: 'Delete all games',
                description: 'Deletes all games',
                onTap: () {
                  _confirm(context, 'Do you wish to delete all games?')
                      .then((confirm) {
                    if (confirm) {
                      loaderDialog(context, _deleteAllGames)
                          .then((_) => Navigator.of(context).pop(true));
                    }
                  });
                },
              ),
              SettingsField(
                title: 'Reset all data',
                description: 'Deletes all data and restores the initial state',
                onTap: () {
                  _confirm(context, 'Do you wish to delete all data?')
                      .then((confirm) {
                    if (confirm) {
                      loaderDialog(context, _deleteAllData)
                          .then((_) => Navigator.of(context).pop(true));
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changeTheme(ThemeChanger theme) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 175,
              childAspectRatio: 2.0,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: Palette.values.length * 2,
            itemBuilder: (context, index) {
              Palette color = Palette.values[index ~/ 2];
              bool isDark = index % 2 == 1;
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color.background,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        // Hana for my wife
                        color == Palette.lightPink && isDark
                            ? 'Hana'
                            : color.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: color.isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  theme.updateTheme(color, isDark);
                  _saveTheme(color, isDark);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> _confirm(BuildContext context, String message) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.error),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future _saveTheme(Palette color, bool isDark) async {
    await SettingsProvider.updateSetting(Setting.themeColor, color.id);
    await SettingsProvider.updateSetting(Setting.themeIsDark, isDark ? 1 : 0);
  }

  Future _deleteAllGames() async {
    var database = await DatabaseProvider.gameDatabase;
    await DatabaseProvider.createGameDatabase(database);
  }

  Future _deleteAllData() async {
    var settings = await DatabaseProvider.settingsDatabase;
    await DatabaseProvider.createSettingsDatabase(settings);
    var games = await DatabaseProvider.gameDatabase;
    await DatabaseProvider.createGameDatabase(games);
  }
}
