import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static final PreferenceHelper _instance = PreferenceHelper._internal();
  static SharedPreferences? _prefs;

  factory PreferenceHelper() {
    return _instance;
  }

  PreferenceHelper._internal();

  /// Call once in main before using prefs
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save methods
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<int?> getInt(String key) async {
    return _prefs?.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    return _prefs?.getDouble(key);
  }

  Future<List<String>?> getStringList(String key) async {
    return _prefs?.getStringList(key);
  }

  // Delete and clear
  Future<void> remove(String key) async => await _prefs?.remove(key);

  Future<void> clearAll() async => await _prefs?.clear();
}
