import 'package:shared_preferences/shared_preferences.dart';

class Helper{

  void updateSharedPrefs(List<String> userDetailsList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userDetails", userDetailsList);
  }
}