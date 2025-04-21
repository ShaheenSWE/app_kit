import 'package:get_storage/get_storage.dart';

class AppStorage {
  AppStorage._internal();
  static final AppStorage instance = AppStorage._internal();

  final GetStorage _box = GetStorage();

  /// Saves a value to local storage.
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  Future<T> read<T>(String key, T defaultValue) async {
    final value = _box.read<T>(key);
    return value ?? defaultValue;
  }
  /// Removes a value by key.
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clears all stored values.
  Future<void> clear() async {
    await _box.erase();
  }

  /// Returns all key-value pairs.
  Future<Map<String, dynamic>> getAll() async {
    return {
      for (final key in _box.getKeys().whereType<String>())
        key: _box.read(key),
    };
  }
}
