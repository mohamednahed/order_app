import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static const String _keySeenOnboarding = 'seenOnboarding';
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyRememberMe = 'rememberMe';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get hasSeenOnboarding =>
      _prefs.getBool(_keySeenOnboarding) ?? false;

  static Future<void> setSeenOnboarding() async {
    await _prefs.setBool(_keySeenOnboarding, true);
  }

  static bool get shouldRememberUser => _prefs.getBool(_keyRememberMe) ?? false;

  static User? getUser() {
    final id = _prefs.getString(_keyUserId);
    final name = _prefs.getString(_keyUserName);
    final email = _prefs.getString(_keyUserEmail);

    if (id == null || name == null || email == null) {
      return null;
    }
    return User(id: id, name: name, email: email);
  }

  static Future<void> saveUser(User user, [bool rememberMe = true]) async {
    await _prefs.setString(_keyUserId, user.id);
    await _prefs.setString(_keyUserName, user.name);
    await _prefs.setString(_keyUserEmail, user.email);
    await _prefs.setBool(_keyRememberMe, rememberMe);
  }

  static Future<void> clearUser() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyRememberMe);
  }
}
