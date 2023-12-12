import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/models/game_list.dart';
import 'package:gamesheet/models/settings.dart';
import 'package:gamesheet/widgets/dialog.dart';
import 'package:gamesheet/widgets/settings/section.dart';
import 'package:gamesheet/widgets/settings/field.dart';
import 'package:gamesheet/widgets/settings/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static final Uri trainRules = Uri.parse(
    'https://www.ultraboardgames.com/mexican-train/game-rules.php',
  );
  static final Uri pingRules = Uri.parse(
    'https://www.ultraboardgames.com/five-crowns/game-rules.php',
  );
  static final Uri wizardRules = Uri.parse(
    'https://www.ultraboardgames.com/wizard/game-rules.php',
  );

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    final gameList = Provider.of<GameListModel>(context);
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
                // Named for my wife
                description: settings.themeColor == Palette.lightPink &&
                        settings.themeIsDark
                    ? 'Hana'
                    : (settings.themeIsDark ? 'Dark ' : 'Light ') +
                        settings.themeColor.label,
                suffixWidget: ThemeDisplay.small(themeData: settings.themeData),
                onTap: () => _themePopup(context),
              ),
            ],
          ),
          const Divider(),
          SettingsSection(
            header: 'General',
            children: <Widget>[
              const SettingsField(
                title: 'About',
                description: 'Score tracker for a variety of games',
              ),
              SettingsField(
                title: 'Train',
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
                onTap: () => _confirmDelete(
                  context,
                  'Do you wish to delete all games?',
                  gameList.removeAllGames,
                ),
              ),
              SettingsField(
                title: 'Reset all data',
                description: 'Deletes all data and restores the initial state',
                onTap: () => _confirmDelete(
                  context,
                  'Do you wish to delete all data?',
                  () async {
                    await gameList.removeAllGames();
                    await settings.resetSettings();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _themePopup(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
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
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  settings.updateTheme(color, isDark);
                  Navigator.of(context).pop();
                },
                child: ThemeDisplay.large(
                  themeData: themeData,
                  label: color == Palette.lightPink && isDark
                      ? 'Hana'
                      : color.label,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    String message,
    Future<void> Function() action,
  ) {
    confirmDeleteDialog(context, message).then((confirm) {
      if (confirm) {
        loaderDialog(context, action).then(
          (_) => Navigator.of(context).pop(),
        );
      }
    });
  }
}
