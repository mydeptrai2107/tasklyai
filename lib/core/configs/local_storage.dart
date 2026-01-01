import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    return _prefsInstance.setString(key, value);
  }

  static Future<bool> setListString(String key, List<String> value) async {
    return _prefsInstance.setStringList(key, value);
  }

  static List<String> getListString(String key) {
    final listFromLocal = _prefsInstance.getStringList(key);
    if (listFromLocal != null) {
      return listFromLocal;
    }
    return [];
  }

  static List<dynamic> getListObject(String key) {
    final listFromLocal = _prefsInstance.getString(key);
    if (listFromLocal != null) {
      final list = json.decode(listFromLocal) as List<dynamic>;
      return list;
    }
    return [];
  }

  static Future<bool> setListObject(String key, List<dynamic>? list) {
    final listMap = list?.map((e) => e.toMap()).toList();
    return _prefsInstance.setString(key, jsonEncode(listMap));
  }

  static Future<bool> remove(String key) async {
    return _prefsInstance.remove(key);
  }

  static bool getBool(String key) {
    return _prefsInstance.getBool(key) ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefsInstance.setBool(key, value);
  }
}
