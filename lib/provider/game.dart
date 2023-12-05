import 'package:provider/provider.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/db/game.dart';

class GameProvider extends ChangeNotifier {
  final List<Games>? _games;

  Future<UnmodifiableListView<Games>> get games async =>
      UnmodifiableListView(await GameDatabase.getGames());
}
