import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player.dart';
import 'constants.dart';

class GameUtils {
  static void assignRolesAndWords(List<Player> players) {
    Random rnd = Random();
    int undercoverIndex = rnd.nextInt(players.length);
    List<String> pair = selectRandomWordPair();
    for (int i = 0; i < players.length; i++) {
      if (i == undercoverIndex) {
        players[i].isUndercover = true;
        players[i].secretWord = pair[1];
      } else {
        players[i].secretWord = pair[0];
      }
    }
  }

  static List<String> selectRandomWordPair() {
    Random rnd = Random();
    return AppConstants.wordPairs[rnd.nextInt(AppConstants.wordPairs.length)];
  }

  static void navigateWithFade(BuildContext context, Widget destination,
      {bool replace = false}) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
    if (replace) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }
}
