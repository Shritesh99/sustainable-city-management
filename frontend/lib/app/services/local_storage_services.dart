import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

/// contains all service to get data from local
class LocalStorageServices {
  static final LocalStorageServices _localStorageServices =
      LocalStorageServices._internal();

  factory LocalStorageServices() {
    return _localStorageServices;
  }
  LocalStorageServices._internal();

  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Future<void> initStorage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool('first_run') ?? true) {
  //     await FlutterSecureStorage().deleteAll();

  //     prefs.setBool('first_run', false);
  //   }
  // }

  // to save data in local, you can use SharedPreferences for simple data
  // or Sqflite for more complex data

  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    var value = await storage.read(key: key);
    return value;
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
}
