import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  static SharedPreferences? _pref;

  static Future<void> init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  static Future<void> setEmail(String email) async {
    await _pref?.setString("email", email);
  }

  static String? getEmail() {
    return _pref?.getString("email");
  }

  static Future<void> setPassword(String password) async {
    await _pref?.setString("password", password);
  }

  static String? getPassword() {
    return _pref?.getString("password");
  }

  static Future<void> setFirstTime(bool firstTime) async {
    await _pref?.setBool("firstTime", firstTime);
  }

  static bool getFirstTime() {
    return _pref?.getBool("firstTime") ?? true;
  }
}
