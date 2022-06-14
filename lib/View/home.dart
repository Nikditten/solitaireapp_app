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

  bool showCameras = false;

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
      controller = CameraController(widget.cameras.first, ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.bgra8888);
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
      body: Stack(
        children: [
          widget.cameras.isNotEmpty
              ? Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(
                        controller,
                      )),
                )
              : Container(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
                child: SafeArea(
              child: Column(
                children: <Widget>[
                  widget.cameras.isNotEmpty && showCameras
                      // SOURCE:
                      // https://www.geeksforgeeks.org/flutter-dropdownbutton-widget/
                      ? DropdownButton(
                          value: widget.cameras.isNotEmpty
                              ? widget.cameras.first
                              : null,
                          items: widget.cameras.map((CameraDescription camera) {
                            return DropdownMenuItem<CameraDescription>(
                              value: camera,
                              child: Text(
                                camera.lensDirection ==
                                        CameraLensDirection.front
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
                ],
              ),
            )),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        splashColor: Colors.blue,
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsView(),
            ),
          );
        },
        onDoubleTap: () {
          setState(() {
            showCameras = !showCameras;
          });
        },
        child: FloatingActionButton(
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
          child: const Icon(Icons.camera_alt_outlined),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
