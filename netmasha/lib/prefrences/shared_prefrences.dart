//Save user token and theme
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;

  SharedPref._privateConstructor();

  static Future<SharedPref> getInstance() async {
    _preferences ??= await SharedPreferences.getInstance();
    return SharedPref._privateConstructor();
  }

  Future<void> setToken(String token) async {
    await _preferences?.setString("token", token);
  }

  Future<String> getToken() async {
    return _preferences?.getString("token") ?? "";
  }

  Future<void> cleanToken() async {
    await _preferences?.remove("token");
  }

  Future<void> cleanSharedPref() async {
    await _preferences?.clear();
  }
}
