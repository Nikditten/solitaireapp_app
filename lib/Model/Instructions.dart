

class Instructions {
  final List instructions;

  Instructions({required this.instructions});

  factory Instructions.fromJson(Map<String, dynamic> json) {
    return Instructions(
      instructions: json['instructions'],
    );
  }
}