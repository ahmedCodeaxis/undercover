# Flutter Undercover Game

## Overview
Flutter Undercover Game is a multiplayer party game where players take on the roles of citizens and an undercover agent. The objective for the citizens is to identify the undercover agent, while the undercover agent tries to blend in and avoid detection.

## Project Structure
The project is organized into the following directories and files:

```
flutter_undercover_game
├── lib
│   ├── main.dart                  # Entry point of the application
│   ├── models
│   │   ├── player.dart            # Defines the Player class
│   │   └── game_state.dart        # Manages the game state
│   └── screens
│       ├── player_setup_screen.dart # Sets up players and starts the game
│       ├── role_reveal_screen.dart  # Reveals roles and secret words to players
│       └── game_round_screen.dart   # Handles game rounds and voting process
├── pubspec.yaml                   # Flutter project configuration
└── README.md                      # Documentation for the project
```

## Setup Instructions
1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd flutter_undercover_game
   ```

2. **Install dependencies**:
   Run the following command to install the required packages:
   ```
   flutter pub get
   ```

3. **Run the application**:
   Use the following command to start the application:
   ```
   flutter run
   ```

## Gameplay Instructions
- Players will enter their names during the setup phase.
- The game will randomly assign roles (citizen or undercover) and secret words to each player.
- Players will take turns revealing their roles and secret words.
- During the game rounds, players will vote to eliminate suspected undercover agents.
- The game continues until either the undercover agent is eliminated or the citizens lose.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.