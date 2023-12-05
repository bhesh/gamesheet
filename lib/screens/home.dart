import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:material_symbols_icons/symbols.dart';
import './home/home_menu.dart';
import './home/game_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamesheet'),
        actions: <Widget>[
          HomeMenuList(onSelected: _navigate),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GameList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _navigate(const CreateGameScreen()),
        tooltip: 'New Game',
        child: const Icon(Symbols.add),
      ),
    );
  }

  void _removeGame(int gameId) {
    GameDatabase.removeGame(gameId).then((_) => _fetchGames());
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
