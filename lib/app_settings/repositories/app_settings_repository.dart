import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

class AppSettingsRepository {
  const AppSettingsRepository({required this.secureStorage}) : super();

  final FlutterSecureStorage secureStorage;

  Future<String?> _readKey(String key) async {
    return secureStorage.read(key: key);
  }

  Future<Protocol> get protocol async {
    final protocol = await _readKey('protocol');
    if (protocol == null) {
      return const Protocol.dirty('http');
    }
    return Protocol.dirty(protocol);
  }

  Future<Hostname> get hostname async {
    final hostname = await _readKey('hostname');
    if (hostname == null) {
      return const Hostname.pure();
    }
    return Hostname.dirty(hostname);
  }

  Future<Port> get port async {
    final port = await _readKey('port');
    if (port == null) {
      return const Port.pure();
    }
    return Port.dirty(port);
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
}