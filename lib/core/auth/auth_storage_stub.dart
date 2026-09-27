import 'package:follio/core/auth/auth_storage.dart';
import 'package:follio/core/auth/secure_auth_storage.dart';

AuthStorage getPlatformAuthStorage() => SecureAuthStorage();
