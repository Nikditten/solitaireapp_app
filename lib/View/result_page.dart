import 'package:flutter/foundation.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:solitaireapp/Helper/apihelper.dart';
import 'package:solitaireapp/Model/Instructions.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  static APIHelper api = APIHelper();


  late String moveFrom;
  late String moveCard;
  late String moveTo;

  @override
  void initState() {
    super.initState();
    api.analyzeImage(widget.file).then((value) {
      moveFrom = value.moveFrom;
      moveCard = value.moveCard;
      moveTo = value.moveTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 10),
              child: const Text(
                "Foretag dette træk",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 400,
                child: kIsWeb
                    ? Image.network(widget.file.path)
                    : Image.asset(widget.file.path),
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Analysér næste træk"),
                style: ButtonStyle(
                  // SOURCE: https://stackoverflow.com/questions/66835173/how-to-change-background-color-of-elevated-button-in-flutter-from-function
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.all(25),
              child: Text(
                "Flyt $moveCard fra $moveFrom til $moveTo",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
