import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Contains all services to get data from local storage
class LocalStorageServices {
  static final LocalStorageServices _localStorageServices =
      LocalStorageServices._internal();

  factory LocalStorageServices({FlutterSecureStorage? storage}) {
    _localStorageServices._setStorage(storage);
    return _localStorageServices;
  }

  LocalStorageServices._internal();

  FlutterSecureStorage? _storage;

  FlutterSecureStorage get storage => _storage!;

  void _setStorage(FlutterSecureStorage? storage) {
    _storage ??= storage ?? const FlutterSecureStorage();
  }

  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> read(String key) async {
    var value = await storage.read(key: key) ?? '';
    return value;
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
}
