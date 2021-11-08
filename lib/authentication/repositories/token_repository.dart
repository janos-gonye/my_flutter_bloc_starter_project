import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepository {
  const TokenRepository({
    required this.secureStorage,
  }) : super();

  final FlutterSecureStorage secureStorage;

  Future<String?> _readKey(String key) async {
    return secureStorage.read(key: key);
  }

  Future<String?> get accessToken async {
    return await _readKey('accessToken');
  }

  Future<String?> get refreshToken async {
    return await _readKey('refreshToken');
  }

  Future<void> write({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: 'accessToken', value: accessToken);
    await secureStorage.write(key: 'refreshToken', value: refreshToken);
  }
}
