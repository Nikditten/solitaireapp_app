import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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
    // Load shareed prefrerences/user defaults
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    // Because last line was the type Future, we need to await the result
    final SharedPreferences prefs = await _prefs;

    // Get ip-address of API, in case the returned value is null
    // Default ip-address is: 0.0.0.0:8000
    var apiURL = prefs.getString("apiURL") ?? "0.0.0.0:8000";

    print("URL: " + apiURL);

    // Read image as bytes
    Uint8List bytes = await inputFile.readAsBytes();

    // Encode bytes into base64
    String encodedImage = base64Encode(bytes);

    // Init the response as a return of the post request we make
    final response = await http.post(
      // Add base url with the url where the api expects the image
      Uri.http(apiURL, '/analyze_image'),
      // Add content type to header
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Create body as json
      // Insert base64 encoded bytes as string
      body: jsonEncode(<String, String>{
        'image_string': encodedImage,
      }),
    );

    // Handle response from API
    if (response.statusCode == 200 && response.body != "null") {
      // SOURCE
      // https://www.tutorialspoint.com/flutter/flutter_accessing_rest_api.htm#
      // https://stackoverflow.com/questions/54474689/how-do-i-return-error-from-a-future-in-dart

      // If body is not null and status code is 200,
      // convert json response to list of Instruction objects
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Instructions>((json) => Instructions.fromJson(json))
          .toList();
      // Otherwise return status code, description and body returned from API
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
