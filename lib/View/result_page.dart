import 'package:flutter/foundation.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:solitaireapp/Helper/Web/apihelperweb.dart';
import 'package:solitaireapp/Helper/apihelper.dart';
import 'package:solitaireapp/Model/Instructions.dart';
import 'package:solitaireapp/View/ViewUtil/instruction.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  static APIHelper api = APIHelper();
  static APIHelperWeb api_web = APIHelperWeb();

  bool gameOver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 10),
                child: const Text(
                  "Foretag disse træk",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder<List<Instructions>>(
                future: kIsWeb
                    ? api_web.analyzeImage(widget.file)
                    : api.analyzeImage(widget.file),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(
                      child: Column(
                        children: [
                          const Text(
                            'An error has occurred!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(snapshot.error.toString()),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      // SOURCE
                      // https://medium.com/@AnInsightfulTechie/flutter-displaying-dynamic-contents-using-listview-builder-f2cedb1a19fb
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return InstructionView(
                                instruction: snapshot.data![index]);
                          },
                          itemCount: snapshot.data!.length),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_forward),
          backgroundColor: Colors.red,
        ));
  }
}
