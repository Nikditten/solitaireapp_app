import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:solitaireapp/View/ViewUtil/board_of_cards.dart';
import 'package:solitaireapp/View/result_page.dart';
import 'package:solitaireapp/View/settings.dart';

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
    if (widget.cameras.isEmpty) {
      print('No camera available');
    } else {
      controller = CameraController(widget.cameras.first, ResolutionPreset.low);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
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
                "Dit spil",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            widget.cameras.isNotEmpty
                ? DropdownButton(
                    value:
                        widget.cameras.isNotEmpty ? widget.cameras.first : null,
                    items: widget.cameras.map((CameraDescription camera) {
                      return DropdownMenuItem<CameraDescription>(
                        value: camera,
                        child: Text(
                          camera.lensDirection == CameraLensDirection.front
                              ? 'Frontkamera'
                              : 'Bagkamera',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller = CameraController(
                          widget.cameras.firstWhere(
                            (CameraDescription camera) => camera == value,
                          ),
                          ResolutionPreset.low,
                        );
                        controller.initialize().then((_) {
                          if (!mounted) {
                            return;
                          }
                          setState(() {});
                        });
                      }
                    },
                  )
                : Container(),
            widget.cameras.isNotEmpty
                ? Center(
                    child: SizedBox(
                        width: kIsWeb
                            ? MediaQuery.of(context).size.width / 2 + 100
                            : MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height - 300,
                        child: CameraPreview(
                          controller,
                        )),
                  )
                : Container(),
            Container(
              width: 200,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.cameras.isNotEmpty) {
                    controller.takePicture().then((file) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(file: file),
                        ),
                      );
                    });
                  } else {
                    return;
                  }
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                child: const Text("Analysér"),
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
