import 'local.dart';

class DBWrapper {
  final _flutterSecureStorage = const FlutterSecureStorageManager();

  /// Get data from secure storage

  Future<String> getSecuredValue(String key, {String defaultValue = ''}) async {
    try {
      return await _flutterSecureStorage.getSecuredValue(key);
    } catch (error) {
      return defaultValue;
    }
  }

  /// Save data in secure storage
  Future<void> saveValueSecurely(String key, String value) async =>
      _flutterSecureStorage.saveValueSecurely(key, value);

  /// Delete data from secure storage
  Future<void> deleteSecuredValue(String key) async =>
      _flutterSecureStorage.deleteSecuredValue(key);

  /// Delete all data from secure storage
  Future<void> deleteAllSecuredValues() async =>
      _flutterSecureStorage.deleteAllSecuredValues();
}
