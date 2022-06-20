import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

// THIS FILE IS ONLY USED FOR EASIER DEBUGGING

class _SettingsViewState extends State<SettingsView> {
  // Controller to control the TextField widget
  TextEditingController apiurlController = TextEditingController();

  //SOURCE:
  // https://pub.dev/packages/shared_preferences/example
  // Get shared preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Svae the new api ip-address to shared preference
  void updateApiURL(String url) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("apiURL", url);
  }

  // Get the api ip-address saved in shared preferences
  void getApiUrl() async {
    final SharedPreferences prefs = await _prefs;
    var url = prefs.getString("apiURL") ?? "";
    // Set TextField widget value to the ip-address saved in shared preferences
    apiurlController.text = url;
  }

  // Get api ip-address when view is build
  @override
  void initState() {
    super.initState();
    getApiUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Add title
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 10),
              child: const Text(
                "Indstillinger",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Add TextField
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: apiurlController,
                decoration: const InputDecoration(
                  labelText: "IP-addresse til api",
                  hintText: "192.168.1.1",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Add Save button
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Save ip-address and go back to camera view
                  updateApiURL(apiurlController.text);
                  Navigator.pop(context);
                },
                child: const Text("Gem og afslut"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
