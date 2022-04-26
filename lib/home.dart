import 'package:flutter/material.dart';
import 'package:solitaireapp/result_page.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late CameraController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
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
                "Dit spil",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
              width: MediaQuery. of(context). size. width - 20,
              height: MediaQuery. of(context). size. height - 300,
              child: CameraPreview(
                controller,
              )
            ),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  controller.takePicture().then((file) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(file: file),
                      ),
                    );
                  });
                },
                child: Text("Analysér"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
