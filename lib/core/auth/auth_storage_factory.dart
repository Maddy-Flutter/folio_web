import 'package:follio/core/auth/auth_storage.dart';
import 'auth_storage_stub.dart'
    if (dart.library.js_interop) 'auth_storage_web.dart';

abstract final class AuthStorageFactory {
  static AuthStorage create() => getPlatformAuthStorage();
}

AuthStorage createPlatformAuthStorage() => getPlatformAuthStorage();
