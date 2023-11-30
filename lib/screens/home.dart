import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:gamesheet/screens/settings.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/game_list.dart';
import 'package:material_symbols_icons/symbols.dart';

enum HomeMenuItem {
  refresh('Refresh'),
  settings('Settings');

  final String label;

  const HomeMenuItem(this.label);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Game>? _games;

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamesheet'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Symbols.refresh),
            tooltip: 'Refresh Game List',
            onPressed: _fetchGames,
          ),
          PopupMenuButton<HomeMenuItem>(
            onSelected: (item) {
              switch (item) {
                case HomeMenuItem.refresh:
                  _fetchGames();
                case HomeMenuItem.settings:
                  _navigate(const SettingsScreen());
              }
            },
            itemBuilder: (_) => HomeMenuItem.values.map((item) {
              return PopupMenuItem<HomeMenuItem>(
                value: item,
                child: Text(item.label),
              );
            }).toList(),
          ),
        ],
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: _games == null
          ? SpinKitRing(
              color: Theme.of(context).colorScheme.primary,
              size: 50,
            )
          : Padding(
              padding: EdgeInsets.only(top: 8),
              child: GameList(
                games: _games!,
                onTap: (context, index) =>
                    _navigate(GameScreen(_games![index])),
                onDelete: (context, index) {
                  int? id = _games == null ? null : _games![index].id;
                  if (id != null) _removeGame(id!);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _navigate(const CreateGameScreen()),
        tooltip: 'New Game',
        child: const Icon(Symbols.add),
      ),
    );
  }

  void _fetchGames() {
    GameProvider.getGames().then((games) => setState(() => _games = games));
  }

  void _removeGame(int gameId) {
    GameProvider.removeGame(gameId).then((_) => _fetchGames());
  }

  Future _navigate(Widget screen) async {
    final bool? reload = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
    if (reload != null && reload!) _fetchGames();
  }
}
