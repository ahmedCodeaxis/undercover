import 'player.dart';
import '../utils/constants.dart';

class GameState {
  List<Player> players;
  final List<List<String>> wordPairs = AppConstants.wordPairs;
  int currentRound;

  GameState({required this.players, this.currentRound = 1});
}
