import 'package:flutter/foundation.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:solitaireapp/Helper/Web/apihelperweb.dart';
import 'package:solitaireapp/Helper/apihelper.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  static APIHelper api = APIHelper();
  static APIHelperWeb api_web = APIHelperWeb();

  int moveFrom = -1;
  String moveCard = "";
  int moveTo = -1;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      api_web.analyzeImage(widget.file).then((response) {
        setState(() {
          moveFrom = response.moveFrom;
          moveCard = response.moveCard;
          moveTo = response.moveTo;
        });
      });
    } else {
      api.analyzeImage(widget.file).then((response) {
        setState(() {
          moveFrom = response.moveFrom;
          moveCard = response.moveCard;
          moveTo = response.moveTo;
        });
      });
    }
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
            moveCard != ""
                ? Center(
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        moveCard.isNotEmpty && moveFrom != -1 && moveTo != -1
                            ? "Flyt '$moveCard' fra kolonne $moveFrom til kolonne $moveTo"
                            : "Fejl efter api response",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
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
          ],
        ),
      ),
    );
  }
}
