import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game_provider.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:material_symbols_icons/symbols.dart';
import './home/home_menu.dart';
import './home/game_list.dart';

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
        title: const Text('Gamesheet'),
        actions: <Widget>[
          HomeMenuList(onSelected: _navigate),
        ],
      ),
      body: _games == null
          ? SpinKitRing(
              color: Theme.of(context).colorScheme.primary,
              size: 50,
            )
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GameList(
                games: _games!,
                onTap: (index) {
                  if (_games != null && index < _games!.length)
                    _navigate(GameScreen(_games![index]));
                },
                onDelete: (index) {
                  if (_games != null && index < _games!.length) {
                    int? id = _games![index].id;
                    if (id != null) _removeGame(id!);
                  }
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

  void _navigate(Widget screen) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(builder: (context) => screen),
    )
        .then((reload) {
      if (reload != null && reload!) _fetchGames();
    });
  }
}
