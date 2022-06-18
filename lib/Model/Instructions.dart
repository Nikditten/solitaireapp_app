// SOURCE:
// https://docs.flutter.dev/cookbook/networking/background-parsing
class Instructions {
  final String moveFrom, moveTo, moveCard, regCard;
  final bool getTalon, gameOver;
  bool done;

  Instructions(
      {required this.moveFrom,
      required this.moveTo,
      required this.moveCard,
      required this.getTalon,
      required this.done,
      required this.gameOver,
      required this.regCard});

  factory Instructions.fromJson(Map<String, dynamic> json) {
    return Instructions(
        moveFrom: json['move_from'] as String,
        moveTo: json['move_to'] as String,
        moveCard: json['move_card'] as String,
        getTalon: json['get_talon'] as bool,
        gameOver: json['game_over'] as bool,
        regCard: json['reg_card'] as String,
        done: false);
  }
}
