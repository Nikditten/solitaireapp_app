import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:solitaireapp/View/result_page.dart';
import 'package:solitaireapp/View/settings.dart';

// Everything that has to do with the camera is based on this source:
// https://pub.dev/packages/camera

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.cameras}) : super(key: key);
  // This view takes a list of all available cameras.
  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController controller;

  bool showCameras = false;

  // SOURCE: https://pub.dev/packages/camera
  @override
  void dispose() {
    // Delete the controller
    controller.dispose();
    super.dispose();
  }

  // SOURCE: https://pub.dev/packages/camera
  @override
  void initState() {
    super.initState();
    // Init camera controller
    // Check if any cameras available
    if (widget.cameras.isEmpty) {
      print('No camera available');
    } else {
      // Get the first available camera (Often the camera on the back of the phone)
      // Set resolution to max
      // iPhone has the bgra8888 image format
      controller = CameraController(widget.cameras.first, ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.bgra8888);
      controller.initialize().then((_) {
        if (!mounted) {
          // Uf the controller couldn't be initialize do nothing.
          return;
        }
        // Tell the ui to update
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Show camera preview
          // Only if there are any camera available
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
                  // For debug purposes implement a dropdown
                  // to select which camera to use
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
                          // Update to new camera, if user selects a new camera to use
                          onChanged: (value) {
                            if (value != null) {
                              controller = CameraController(
                                widget.cameras.firstWhere(
                                  (CameraDescription camera) => camera == value,
                                ),
                                ResolutionPreset.max,
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
      // In order to use multiple tap gestures, we are using an InkWell widget.
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
            // Show camera dropdown, if FAB is double tapped
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
                    // When an image is captured give it to the ResultPage view
                    // And send the user to that view.
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
