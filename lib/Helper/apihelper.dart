import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solitaireapp/Model/Instructions.dart';

class APIHelper {
  //SOURCES:
  //  https://www.bezkoder.com/dart-base64-image/
  //  https://docs.flutter.dev/cookbook/networking/send-data
  //  https://docs.flutter.dev/cookbook/networking/background-parsing

  Future<List<Instructions>> analyzeImage(XFile inputFile) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    final SharedPreferences prefs = await _prefs;

    var apiURL = prefs.getString("apiURL") ?? "0.0.0.0:8000";

    print("URL: " + apiURL);

    final bytes = File(inputFile.path).readAsBytesSync();

    String encodedImage = base64Encode(bytes);

    final response = await http.post(
      Uri.http(apiURL, '/analyze_image'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'image_string': encodedImage,
      }),
    );

    if (response.statusCode == 200 && response.body != "null") {
      // SOURCE
      // https://www.tutorialspoint.com/flutter/flutter_accessing_rest_api.htm#
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Instructions>((json) => Instructions.fromJson(json))
          .toList();
    } else if (response.statusCode == 400) {
      return Future.error(response.statusCode.toString() +
          " - " +
          response.reasonPhrase.toString() +
          " //Body: " +
          response.body);
    } else if (response.statusCode == 401) {
      return Future.error(response.statusCode.toString() +
          " - " +
          response.reasonPhrase.toString() +
          " //Body: " +
          response.body);
    } else if (response.statusCode == 403) {
      return Future.error(response.statusCode.toString() +
          " - " +
          response.reasonPhrase.toString() +
          " //Body: " +
          response.body);
    } else if (response.statusCode == 404) {
      return Future.error(response.statusCode.toString() +
          " - " +
          response.reasonPhrase.toString() +
          " //Body: " +
          response.body);
    } else if (response.statusCode == 500) {
      return Future.error(response.statusCode.toString() +
          " - " +
          response.reasonPhrase.toString() +
          " //Body: " +
          response.body);
    } else if (response.body == "null" || response.body.isEmpty) {
      return Future.error(response.statusCode.toString() +
          " - Empty response\n\nBody:\n" +
          response.body);
    } else {
      return Future.error("Unknown error");
    }
  }
}
