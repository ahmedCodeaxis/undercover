import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/game_state.dart';
import '../utils/game_utils.dart';
import '../widgets/animated_button.dart';
import 'role_reveal.dart';

class PlayerSetupScreen extends StatefulWidget {
  @override
  _PlayerSetupScreenState createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>(); 
  int numPlayers = 3;
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateControllers() {
    controllers = List.generate(numPlayers, (_) => TextEditingController());
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      List<Player> players = controllers
          .map((controller) => Player(name: controller.text))
          .toList();
      GameUtils.assignRolesAndWords(players);
      GameState gameState = GameState(players: players);
      GameUtils.navigateWithFade(
        context,
        RoleRevealScreen(gameState: gameState, currentIndex: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text('Number of Players (3-12): '),
                  Expanded(
                    child: Slider(
                      value: numPlayers.toDouble(),
                      min: 3,
                      max: 12,
                      divisions: 9,
                      label: numPlayers.toString(),
                      onChanged: (value) {
                        setState(() {
                          numPlayers = value.toInt();
                          _updateControllers();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: numPlayers,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1} Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a name';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ),
              AnimatedButton(
                onPressed: _startGame,
                label: 'Start Game',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
