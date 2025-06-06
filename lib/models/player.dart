class Player {
  String name;
      bool isUndercover;
  String secretWord;
  bool eliminated;

  Player({
    required this.name,
    this.isUndercover = false,
       this.secretWord = '',
    this.eliminated = false,
  });
}
