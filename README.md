# undercover

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



->run this to get the needed packages:

flutter pub get



->Start the App:


Launch the app on your device or emulator:

flutter run

->App Structure






lib/main.dart: Starts the app and sets up the teal and amber theme.



lib/models/: Holds game data like player info (player.dart) and game state (game_state.dart).



lib/screens/: Contains the app’s screens:





player_setup.dart: Where you enter player names.



role_reveal.dart: Shows each player their secret role and word.



game_round.dart: Handles voting to find the undercover player.



lib/utils/: Has helper files:





constants.dart: Stores colors and word pairs (like "Cat" vs. "Tiger").



game_utils.dart: Includes game logic like picking roles.



lib/widgets/: Reusable UI parts like the animated button (animated_button.dart).

