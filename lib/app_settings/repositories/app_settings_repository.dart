import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

class AppSettingsRepository {
  const AppSettingsRepository({
    required this.secureStorage,
    required this.dio,
  }) : super();

  final FlutterSecureStorage secureStorage;
  final Dio dio;

  Future<String?> _readKey(String key) async {
    return secureStorage.read(key: key);
  }

  Future<Protocol> get protocol async {
    final protocol = await _readKey('protocol');
    if (protocol == null) {
      return const Protocol('https');
    }
    return Protocol(protocol);
  }

  Future<Hostname> get hostname async {
    final hostname = await _readKey('hostname');
    if (hostname == null) {
      return const Hostname('');
    }
    return Hostname(hostname);
  }

  Future<Port> get port async {
    final port = await _readKey('port');
    if (port == null) {
      return const Port('');
    }
    return Port(port);
  }

  Future<void> write({
    required Hostname hostname,
    required Protocol protocol,
    required Port port,
  }) async {
    await secureStorage.write(key: 'protocol', value: protocol.value);
    await secureStorage.write(key: 'hostname', value: hostname.value);
    await secureStorage.write(key: 'port', value: port.value);
  }

  Future<Uri?> get serverUri async {
    final _protocol = await protocol;
    final _hostname = await hostname;
    final _port = await port;
    if (_protocol.invalid || _hostname.invalid || _port.invalid) {
      return null;
    }
    return Uri(
      scheme: _protocol.value,
      host: _hostname.value,
      port: int.parse(_port.value),
    );
  }
}
