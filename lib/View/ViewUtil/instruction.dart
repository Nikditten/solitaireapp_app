import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:solitaireapp/Model/Instructions.dart';

class InstructionView extends StatefulWidget {
  const InstructionView(
      {Key? key, required this.instruction})
      : super(key: key);

  final Instructions instruction;

  @override
  State<InstructionView> createState() => _InstructionViewState();
}

class _InstructionViewState extends State<InstructionView> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.instruction.getTalon ? Colors.orange[100] : Colors.white,
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Flyt kort: " + widget.instruction.moveCard,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fra kolonne " +
                      widget.instruction.moveFrom +
                      " til kolonne " +
                      widget.instruction.moveTo,
                  style: const TextStyle(fontSize: 15, color: Colors.black,),
                ),
                Text(
                  "Talon: " + (widget.instruction.getTalon ? "Ja" : "Nej"),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
