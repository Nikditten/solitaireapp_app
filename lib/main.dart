import 'package:flutter/material.dart';
import 'package:solitaireapp/View/home.dart';
import 'dart:async';
import 'package:camera/camera.dart';

// SOURCE: https://pub.dev/packages/camera
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get available cameras.
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Application root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitaire',
      home: HomePage(cameras: cameras)
    );
  }
}
