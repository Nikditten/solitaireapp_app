import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solitaireapp/Instructions.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    uploadFile(widget.file);
  }

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
                child: Image.asset(widget.file.path),
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

//SOURCES:
//  https://www.bezkoder.com/dart-base64-image/
//  https://docs.flutter.dev/cookbook/networking/send-data

uploadFile(XFile inputFile) async {
  final bytes = File(inputFile.path).readAsBytesSync();
  String encodedImage = base64Encode(bytes);

  print("Sender request");
  final response = await http.post(
    Uri.http('192.168.84.85:8000', '/analyze_image'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'image_string': encodedImage,
    }),
  );
  print("Venter på response");

  print(response.statusCode.toString() +
      " - " +
      response.reasonPhrase.toString());
  print(response.body.toString());
  print(response.headers.toString());
}
