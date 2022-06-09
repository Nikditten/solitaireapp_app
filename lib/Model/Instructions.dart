
// SOURCE:
// https://docs.flutter.dev/cookbook/networking/background-parsing
class Instructions {
  final int moveFrom;
  final int moveTo;
  final String moveCard;

  const Instructions({
    required this.moveFrom,
    required this.moveTo,
    required this.moveCard
    });

  factory Instructions.fromJson(Map<String, dynamic> json) {
    return Instructions(
      moveFrom: json['next_move']['move_from'] as int,
      moveTo: json['next_move']['move_to'] as int,
      moveCard: json['next_move']['move_card'] as String
    );
  }
}
