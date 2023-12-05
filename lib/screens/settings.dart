import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/settings.dart';
import 'package:gamesheet/common/themes.dart';
import 'package:gamesheet/db/app.dart';
import 'package:gamesheet/db/settings.dart';
import 'package:gamesheet/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import './settings/settings.dart';

final Uri trainRules = Uri.parse(
  'https://www.ultraboardgames.com/mexican-train/game-rules.php',
);
final Uri pingRules = Uri.parse(
  'https://www.ultraboardgames.com/five-crowns/game-rules.php',
);
final Uri wizardRules = Uri.parse(
  'https://www.ultraboardgames.com/wizard/game-rules.php',
);

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
                suffixWidget: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.data.colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.data.colorScheme.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                onTap: () => _changeTheme(theme),
              ),
            ],
          ),
          const Divider(),
          SettingsSection(
            header: 'General',
            children: <Widget>[
              SettingsField(
                title: 'Train Game',
                description:
                    'A standard domino game where the goal to score the least amount of points',
                onTap: () => launchUrl(trainRules),
              ),
              SettingsField(
                title: 'Ping',
                description:
                    'A card game where you combine cards into sets and runs to score the least amount of points',
                onTap: () => launchUrl(pingRules),
              ),
              SettingsField(
                title: 'Wizard',
                description: 'A card game with initial bids and tricks',
                onTap: () => launchUrl(wizardRules),
              ),
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
              ThemeData themeData = buildTheme(color.background, isDark);
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        // Hana for my wife
                        color == Palette.lightPink && isDark
                            ? 'Hana'
                            : color.label,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: themeData.colorScheme.onPrimary),
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
    await SettingsDatabase.updateSetting(Setting.themeColor, color.id);
    await SettingsDatabase.updateSetting(Setting.themeIsDark, isDark ? 1 : 0);
  }

  Future _deleteAllGames() async {
    var database = await AppDatabase.gameDatabase;
    await AppDatabase.createGameDatabase(database);
  }

  Future _deleteAllData() async {
    var settings = await AppDatabase.settingsDatabase;
    await AppDatabase.createSettingsDatabase(settings);
    var games = await AppDatabase.gameDatabase;
    await AppDatabase.createGameDatabase(games);
  }
}
