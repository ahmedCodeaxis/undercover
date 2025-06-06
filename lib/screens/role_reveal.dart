import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/game_utils.dart';
import '../widgets/animated_button.dart';
import 'game_round.dart';

class RoleRevealScreen extends StatefulWidget {
  final GameState gameState; 
  final int currentIndex;

  RoleRevealScreen({required this.gameState, required this.currentIndex});

  @override
  _RoleRevealScreenState createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  bool reveal = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentIndex >= widget.gameState.players.length) {
      return GameRoundScreen(gameState: widget.gameState);
    }
    var player = widget.gameState.players[widget.currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Private Role')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Player: ${player.name}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 20),
            reveal
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          player.isUndercover
                              ? 'Role: Undercover'
                              : 'Role: Citizen',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Your secret word: ${player.secretWord}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : Text('Tap the button to reveal your role and secret word.'),
            Spacer(),
            AnimatedButton(
              onPressed: () {
                setState(() {
                  reveal = true;
                  _animationController.forward();
                });
              },
              label: reveal ? 'Next Player' : 'Reveal',
            ),
            if (reveal)
              AnimatedButton(
                onPressed: () {
                  GameUtils.navigateWithFade(
                    context,
                    RoleRevealScreen(
                      gameState: widget.gameState,
                      currentIndex: widget.currentIndex + 1,
                    ),
                    replace: true,
                  );
                },
                label: 'Continue',
                isTextButton: true,
              ),
          ],
        ),
      ),
    );
  }
}
