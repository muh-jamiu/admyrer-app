import 'package:hive/hive.dart';
import 'package:admyrer/models/user.dart';

class CacheHelper {
  static final CacheHelper _instance = CacheHelper._internal();
  factory CacheHelper() => _instance;
  CacheHelper._internal();

  final Box _box = Hive.box('cacheBox');

  Future<void> insertCache(String key, List<UserModel> value) async {
    await _box.put(key, {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Map<String, dynamic>? getCache(String key) {
    final cachedData = _box.get(key);
    if (cachedData != null) {
      return {
        'value': cachedData['value'],
        'timestamp': cachedData['timestamp'],
      };
    }
    return null;
  }

  Future<void> deleteCache(String key) async {
    await _box.delete(key);
  }
}
