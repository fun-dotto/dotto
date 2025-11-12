import 'package:dotto/domain/user_preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class UserPreferenceRepository {
  static Future<void> setBool(
    UserPreferenceKeys key, {
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.type == bool) {
      await prefs.setBool(key.key, value);
    } else {
      throw TypeError();
    }
  }

  static Future<bool?> getBool(UserPreferenceKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key.key);
  }

  static Future<void> setString(UserPreferenceKeys key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.type == String) {
      await prefs.setString(key.key, value);
    } else {
      throw TypeError();
    }
  }

  static Future<String?> getString(UserPreferenceKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.key);
  }

  static Future<void> setInt(UserPreferenceKeys key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key.type == int) {
      await prefs.setInt(key.key, value);
    } else {
      throw TypeError();
    }
  }

  static Future<int?> getInt(UserPreferenceKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key.key);
  }
}
