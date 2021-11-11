import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationTokenRepository {
  const AuthenticationTokenRepository({
    required this.secureStorage,
  });

  final FlutterSecureStorage secureStorage;

  Future<String?> _readKey(String key) async {
    return secureStorage.read(key: key);
  }

  Future<void> write({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: 'access_token', value: accessToken);
    await secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> get accessToken async {
    return await _readKey('access_token');
  }

  Future<String?> get refreshToken async {
    return await _readKey('refresh_token');
  }

  Future<void> clear() async {
    secureStorage.delete(key: 'access_token');
    secureStorage.delete(key: 'refresh_token');
  }
}
