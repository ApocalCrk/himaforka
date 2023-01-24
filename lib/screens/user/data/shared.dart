import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, message);
  }

  static readPrefStr(String key) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getString(key);
  }

  static getAllData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // get nama, npm, email and return to the map<dynamic, dynamic>
    return pref.getKeys();
  }
}