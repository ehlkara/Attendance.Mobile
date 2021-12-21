import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  List<SecureItem> _items = [];
  static SecureStorage _instance = SecureStorage._();
  FlutterSecureStorage _flutterSecureStorage;

  static SecureStorage get instance => _instance;

  SecureStorage._() {
    _flutterSecureStorage = new FlutterSecureStorage();
  }

  Future<String> read(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  void write(String key, String value) {
    _flutterSecureStorage.write(key: key, value: value);
  }

  void delete(String key) {
    _flutterSecureStorage.delete(key: key);
  }

  Future<List<SecureItem>> _readAll() async {
    final all = await _flutterSecureStorage.readAll();

    return _items = all.keys.map((key) => SecureItem(key, all[key])).toList(growable: false);
  }

  void _deleteAll() async {
    await _flutterSecureStorage.deleteAll();
    _readAll();
  }
}

class SecureItem {
  SecureItem(this.key, this.value);
  final String key;
  final String value;
}
