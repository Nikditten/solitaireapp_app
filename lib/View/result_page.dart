import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:solitaireapp/Helper/apihelper.dart';
import 'package:solitaireapp/Model/Instructions.dart';
import 'package:solitaireapp/View/ViewUtil/instruction.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.file}) : super(key: key);
  // This view take the captured image as a parameter
  final XFile file;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // Init api helper
  static APIHelper api = APIHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Using SafeArea, so view avoids conflicting
        // with the operating systems elements
        //(like toolbar at the of the phone where the clock and cellular signal is shown)
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Show title
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
              // Build the list of instruction
              FutureBuilder<List<Instructions>>(
                // This is the function that return a list of instructions
                future: api.analyzeImage(widget.file),
                builder: (context, snapshot) {
                  // Create a text that say, "an error has occured"
                  // if an error is returned instead of data
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
                    // If the function returns data
                    // Build a ListView displaying the list of instructions
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      // SOURCE
                      // https://medium.com/@AnInsightfulTechie/flutter-displaying-dynamic-contents-using-listview-builder-f2cedb1a19fb
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            // Each instruction is parsed to the InstructionView
                            // that displays the data nicely
                            return InstructionView(
                                instruction: snapshot.data![index]);
                          },
                          // Number of item in the list of instructions
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
        // Go back to the camera by deleting the context
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_forward),
          backgroundColor: Colors.red,
        ));
  }
}
