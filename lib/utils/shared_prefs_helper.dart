import 'package:shared_preferences/shared_preferences.dart';

class Helper{

  void updateSharedPrefs({String? email, String? uid, required bool loggedInStatus}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUID", uid!);
    prefs.setString("currentEmail", email!);
    prefs.setBool("loggedIn", loggedInStatus);
  }

  Future<bool?> extractSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loggedIn");
  }
}