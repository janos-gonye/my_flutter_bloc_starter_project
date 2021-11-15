import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;

class AuthenticationTokenRepository {
  const AuthenticationTokenRepository({
    required this.secureStorage,
  });

  final FlutterSecureStorage secureStorage;

  Future<String?> _readKey(String key) async {
    return secureStorage.read(key: key);
  }

  Future<void> write({
    String? accessToken,
    String? refreshToken,
  }) async {
    if (accessToken != null) {
      await secureStorage.write(
        key: constants.storageKeyAccessToken,
        value: accessToken,
      );
    }
    if (refreshToken != null) {
      await secureStorage.write(
        key: constants.storageKeyRefreshToken,
        value: refreshToken,
      );
    }
  }

  Future<String?> get accessToken async {
    return await _readKey(constants.storageKeyAccessToken);
  }

  Future<String?> get refreshToken async {
    return await _readKey(constants.storageKeyRefreshToken);
  }

  Future<void> clear() async {
    secureStorage.delete(key: constants.storageKeyAccessToken);
    secureStorage.delete(key: constants.storageKeyRefreshToken);
  }
}
