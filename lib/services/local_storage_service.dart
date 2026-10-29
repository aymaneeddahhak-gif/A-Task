import 'local_storage_stub.dart'
    if (dart.library.html) 'local_storage_web.dart';

class LocalStorageService {
  static String? getString(String key) => platformReadStorage(key);

  static void setString(String key, String value) =>
      platformWriteStorage(key, value);

  static void remove(String key) => platformRemoveStorage(key);
}
