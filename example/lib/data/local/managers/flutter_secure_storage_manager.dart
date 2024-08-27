import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../utils/log.dart';

class FlutterSecureStorageManager {
  const FlutterSecureStorageManager();

  /// initialize flutter secure storage
  final flutterSecureStorage = const FlutterSecureStorage();

  /// Get data from secure storage
  Future<String> getSecuredValue(String key) async {
    try {
      var value = await flutterSecureStorage.read(key: key);
      if (value == null || value.isEmpty) {
        value = '';
      }
      return value;
    } catch (error) {
      return '';
    }
  }

  /// Get all data from secure storage
  Future<Map<String, String>> getAllSecuredValue() async {
    try {
      var value = await flutterSecureStorage.readAll();
      if (value.isEmpty) {
        value = {};
      }
      return value;
    } catch (error) {
      return {};
    }
  }

  /// Save data in secure storage
  Future<void> saveValueSecurely(String key, String value) async {
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Delete data from secure storage
  Future<void> deleteSecuredValue(String key) async {
    await flutterSecureStorage.delete(key: key);
  }

  /// Delete all data from secure storage
  Future<void> deleteAllSecuredValues() async {
    await flutterSecureStorage.deleteAll();
  }

  /// Method For Delete & Override from Secure Storage
  Future<void> deleteSaveSecureValue(String key, String value) async {
    try {
      await flutterSecureStorage.delete(key: key);
      await flutterSecureStorage.write(key: key, value: value);
    } catch (e, st) {
      AppLog.error(e, st);
    }
  }
}
