import 'package:flutter/material.dart';
import 'package:solitaireapp/Model/Instructions.dart';

class InstructionView extends StatefulWidget {
  // This view takes a instruction object as argument
  const InstructionView({Key? key, required this.instruction})
      : super(key: key);

  final Instructions instruction;

  @override
  State<InstructionView> createState() => _InstructionViewState();
}

class _InstructionViewState extends State<InstructionView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Mark as completed if the user taps on the instruction
      // Unmark if the user it again afterwards
      onTap: () {
        setState(() {
          widget.instruction.done = !widget.instruction.done;
        });
      },
      child: Container(
        // Define size
        width: MediaQuery.of(context).size.width - 100,

        // Add padding and margin
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),

        // Add design
        // Makes it look like a card, by giving it shadow and round corner
        decoration: BoxDecoration(
          // gameover = card is red
          // gettalon = card is orange[100]
          // instruction completed = green
          // Else = white
          color: widget.instruction.gameOver
              ? Colors.red
              : widget.instruction.done
                  ? Colors.green
                  : widget.instruction.getTalon
                      ? Colors.orange[100]
                      : Colors.white,
          // SOURCE:
          // https://stackoverflow.com/questions/52227846/how-can-i-add-shadow-to-the-widget-in-flutter
          // LINK TO ANSWER: https://stackoverflow.com/a/52228086
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              // Align the two text widgets with space between them
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // Change text based on instruction
                  widget.instruction.getTalon
                      ? "Træk 3 kort fra talon"
                      : "Flyt kort: " + widget.instruction.moveCard,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.instruction.gameOver
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Text(
                  widget.instruction.regCard,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.instruction.gameOver
                          ? Colors.white
                          : Colors.blue),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                // Text based on instruction
                !widget.instruction.getTalon
                    ? !(int.parse(widget.instruction.moveTo) > 6)
                        ? "Fra kolonne " +
                            (int.parse(widget.instruction.moveFrom) + 1)
                                .toString() +
                            " til kolonne " +
                            (int.parse(widget.instruction.moveTo) + 1)
                                .toString()
                        : "Fra kolonne " +
                            (int.parse(widget.instruction.moveFrom) + 1)
                                .toString() +
                            " til foundation"
                    : widget.instruction.moveCard.isNotEmpty
                        ? "Det øverste kort bør være " +
                            widget.instruction.moveCard
                        : "",
                style: TextStyle(
                    fontSize: 15,
                    color: widget.instruction.gameOver
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            // Add gameover text, if the backend (API) marked the game as done
            widget.instruction.gameOver
                ? const SizedBox(
                    height: 20,
                  )
                : Container(),
            widget.instruction.gameOver
                ? const Text(
                    "GAME OVER",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
