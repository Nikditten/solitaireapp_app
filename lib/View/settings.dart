import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  TextEditingController apiurlController = TextEditingController();

  //SOURCE:
  // https://pub.dev/packages/shared_preferences/example
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void updateApiURL(String url) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("apiURL", url);
  }

  void getApiUrl() async {
    final SharedPreferences prefs = await _prefs;
    var url = prefs.getString("apiURL") ?? "";
    apiurlController.text = url;
  }

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
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () {
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
