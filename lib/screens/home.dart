import 'package:flutter/material.dart';
import 'package:gamesheet/db/game.dart';
import 'package:gamesheet/provider/game_provider.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/game_list.dart';
import 'package:gamesheet/widgets/message.dart';
import 'package:material_symbols_icons/symbols.dart';

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
          IconButton(
            icon: Icon(Symbols.more_vert),
            tooltip: 'Menu',
            onPressed: () {},
          ),
        ],
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: _games != null
          ? GameList(
              games: _games!,
              onTap: (context, index) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(_games![index]),
                ),
              ),
              onDelete: (context, index) {
                int? id = _games == null ? null : _games![index].id;
                if (id != null) _removeGame(id!);
              },
            )
          : ScoreboardMessage('Loading...'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? reload = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGameScreen()),
          );
          if (reload != null && reload!) _fetchGames();
        },
        tooltip: 'New Game',
        child: const Icon(Symbols.add),
      ),
    );
  }

  void _fetchGames() {
    new Future<List<Game>>(() async {
      return await GameProvider.getGames();
    }).then((games) => setState(() => _games = games));
  }

  void _removeGame(int gameId) {
    new Future<void>(() async {
      await GameProvider.removeGame(gameId);
    }).then((_) => _fetchGames());
  }
}
