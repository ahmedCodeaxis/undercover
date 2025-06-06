import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/animated_button.dart';

// Screen for game rounds and voting
class GameRoundScreen extends StatefulWidget {
  final GameState gameState;

  GameRoundScreen({required this.gameState});

  @override
  _GameRoundScreenState createState() => _GameRoundScreenState();
}

class _GameRoundScreenState extends State<GameRoundScreen>
    with SingleTickerProviderStateMixin {
  int currentVoterIndex = 0; // Current voter index
  Map<String, String> votes = {}; // Map of votes (voter -> candidate)
  late AnimationController
      _animationController; // Controller for button animation
  late Animation<double> _scaleAnimation; // Scale animation for vote buttons

  @override
  void initState() {
    super.initState();
    // Set up button scale animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up animation controller
    super.dispose();
  }

  // Record a player's vote
  void _castVote(String candidate) {
    String voter = widget.gameState.players
        .where((p) => !p.eliminated)
        .toList()[currentVoterIndex]
        .name;
    votes[voter] = candidate;
    setState(() {
      currentVoterIndex++;
    });
    if (currentVoterIndex >=
        widget.gameState.players.where((p) => !p.eliminated).length) {
      _processVotes();
    }
  }

  // Process votes to determine elimination
  void _processVotes() {
    Map<String, int> count = {};
    votes.forEach((_, candidate) {
      count[candidate] = (count[candidate] ?? 0) + 1;
    });
    int maxVotes = 0;
    String? eliminatedName;
    count.forEach((name, v) {
      if (v > maxVotes) {
        maxVotes = v;
        eliminatedName = name;
      } else if (v == maxVotes) {
        eliminatedName = null; // Tie
      }
    });

    String message;
    if (eliminatedName != null) {
      Player eliminatedPlayer =
          widget.gameState.players.firstWhere((p) => p.name == eliminatedName);
      eliminatedPlayer.eliminated = true;
      message = '$eliminatedName has been eliminated!';
      if (eliminatedPlayer.isUndercover) {
        message += '\nCitizens win!';
        _showEndDialog(message);
        return;
      }
      int remaining =
          widget.gameState.players.where((p) => !p.eliminated).length;
      if (remaining == 2) {
        Player undercover = widget.gameState.players
            .where((p) => !p.eliminated && p.isUndercover)
            .first;
        message += '\nUndercover (${undercover.name}) wins!';
        _showEndDialog(message);
        return;
      }
    } else {
      message = 'Tie! No one is eliminated.';
    }
    _showRoundResult(message);
  }

  // Show dialog with round results
  void _showRoundResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Round ${widget.gameState.currentRound} Result'),
        content: Text(message),
        actions: [
          AnimatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewRound();
            },
            label: 'Next Round',
            isTextButton: true,
          ),
        ],
      ),
    );
  }

  // Show dialog for game end
  void _showEndDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text(message),
        actions: [
          AnimatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            label: 'Back to Setup',
            isTextButton: true,
          ),
        ],
      ),
    );
  }

  // Start a new round
  void _startNewRound() {
    setState(() {
      widget.gameState.currentRound++;
      currentVoterIndex = 0;
      votes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Player> activePlayers =
        widget.gameState.players.where((p) => !p.eliminated).toList();
    if (activePlayers.length < 2) {
      return Scaffold(
        appBar:
            AppBar(title: Text('Game Round ${widget.gameState.currentRound}')),
        body: Center(child: Text('Not enough players to continue.')),
      );
    }
    Player currentVoter = activePlayers[currentVoterIndex];
    return Scaffold(
      appBar:
          AppBar(title: Text('Game Round ${widget.gameState.currentRound}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentVoterIndex < activePlayers.length
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Player ${currentVoter.name}, cast your vote:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  // List of players to vote for
                  Expanded(
                    child: ListView(
                      children: activePlayers
                          .where((p) => p.name != currentVoter.name)
                          .map((p) => ListTile(
                                title: Text(p.name),
                                trailing: AnimatedButton(
                                  onPressed: () => _castVote(p.name),
                                  label: 'Vote',
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              )
            : Center(child: Text('Processing votes...')),
      ),
    );
  }
}
