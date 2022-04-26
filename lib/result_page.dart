import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              child: const Text(
                "Foretag dette træk",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 400,
                child: Image.file(File(widget.file.path)),
              ),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Analysér næste træk"),
                style: ButtonStyle(
                  // SOURCE: https://stackoverflow.com/questions/66835173/how-to-change-background-color-of-elevated-button-in-flutter-from-function
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ),
            Container(
              width: 300,
              margin: EdgeInsets.all(25),
              child: const Text(
                "Ryk kortet i venstre side over på kortet i højre side",
                style: TextStyle(
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
