import 'package:flutter/material.dart';

class BoardOfCards extends StatefulWidget {
  const BoardOfCards({Key? key}) : super(key: key);

  @override
  State<BoardOfCards> createState() => _BoardOfCardsState();
}

class _BoardOfCardsState extends State<BoardOfCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.width - 100,
        color: Colors.green,
        padding: const EdgeInsets.all(10),
        child: GameCard(symbol: Icons.square, color: Colors.black, number: 2));
  }
}

class GameCard extends StatelessWidget {
  const GameCard(
      {Key? key,
      required this.symbol,
      required this.color,
      required this.number})
      : super(key: key);

  final IconData symbol;
  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
      ],
    );
  }
}
