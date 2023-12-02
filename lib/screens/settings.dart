import 'package:flutter/material.dart';
import 'package:gamesheet/provider/database.dart';
import 'package:gamesheet/db/color.dart';
import 'package:gamesheet/widgets/loader.dart';
import 'package:gamesheet/widgets/settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
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
                description: '<current theme>',
                onTap: _changeTheme,
              ),
            ],
          ),
          Divider(),
          SettingsSection(
            header: 'General',
            children: <Widget>[
              SettingsField(
                title: 'About',
                description: 'Score tracker for a variety of games',
                onTap: () {},
              ),
            ],
          ),
          Divider(),
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

  void _changeTheme() {}

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

  Future _deleteAllGames() async {
    var database = await Provider.gameDatabase;
    await Provider.createGameDatabase(database);
  }

  Future _deleteAllData() async {
    var settings = await Provider.settingsDatabase;
    await Provider.createSettingsDatabase(settings);
    var games = await Provider.gameDatabase;
    await Provider.createGameDatabase(games);
  }
}
