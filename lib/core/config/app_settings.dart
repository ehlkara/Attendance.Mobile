import 'dart:convert';

import 'package:flutter/services.dart';

class AppSettings {
  AppSettings(this.baseUrl);

  AppSettings.fromJson(Map<String, dynamic> json) : baseUrl = json["baseUrl"];

  final baseUrl;

  static Future<AppSettings> _load() async {
    String jsonString = await _loadFromAsset();
    final json = jsonDecode(jsonString);
    return new AppSettings.fromJson(json);
  }

  static Future<String> _loadFromAsset() async {
    String json = await rootBundle.loadString("assets/config/app_settings.json");
    return json;
  }

  static AppSettings _instance;

  static Future<void> init() async {
    _instance = await _load();
  }

  static Future<AppSettings> get() async {
    if (_instance == null) {
      _instance = await _load();
    }
    return _instance;
  }
}
