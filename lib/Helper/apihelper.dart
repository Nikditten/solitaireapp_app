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
  // https://docs.flutter.dev/cookbook/networking/background-parsing

  Future<Instructions> analyzeImage(XFile inputFile) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    final SharedPreferences prefs = await _prefs;

    var apiURL = prefs.getString("apiURL") ?? "127.0.0.0:8000";

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

    print(response.statusCode);

    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final instructions = Instructions.fromJson(jsonResponse);
      return instructions;
    } else if (response.statusCode == 400) {
      throw Exception("400 - Bad request");
    } else if (response.statusCode == 401) {
      throw Exception("401 - Unauthorized");
    } else if (response.statusCode == 403) {
      throw Exception("403 - Forbidden");
    } else if (response.statusCode == 404) {
      throw Exception("404 - Not found");
    } else if (response.statusCode == 500) {
      throw Exception("500 - Internal server error");
    } else {
      throw Exception("Unknown error");
    }
  }
}
