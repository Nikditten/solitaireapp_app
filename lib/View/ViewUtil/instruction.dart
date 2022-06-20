import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:solitaireapp/Model/Instructions.dart';

class InstructionView extends StatefulWidget {
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
      onTap: () {
        setState(() {
          widget.instruction.done = !widget.instruction.done;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
                !widget.instruction.getTalon
                    ? !(int.parse(widget.instruction.moveTo) > 6) ? "Fra kolonne " +
                        (int.parse(widget.instruction.moveFrom) + 1)
                            .toString() +
                        " til kolonne " +
                        (int.parse(widget.instruction.moveTo) + 1).toString() : "Fra kolonne " +
                        (int.parse(widget.instruction.moveFrom) + 1)
                            .toString() +
                        " til foundation"
                    : widget.instruction.moveCard.isNotEmpty ? "Det øverste kort bør være " + widget.instruction.moveCard : "",
                style: TextStyle(
                    fontSize: 15,
                    color: widget.instruction.gameOver
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            widget.instruction.gameOver ? const SizedBox(
              height: 20,
            ) : Container(),
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
