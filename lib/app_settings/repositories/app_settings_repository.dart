import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;

class AppSettingsRepository {
  const AppSettingsRepository({
    required this.secureStorage,
  }) : super();

  final FlutterSecureStorage secureStorage;

  Future<String?> _readKey(String key) async {
    return secureStorage.read(key: key);
  }

  Future<Protocol> get protocol async {
    final protocol = await _readKey(constants.storageKeyProtocol);
    if (protocol == null) {
      return const Protocol('https');
    }
    return Protocol(protocol);
  }

  Future<Hostname> get hostname async {
    final hostname = await _readKey(constants.storageKeyHostname);
    if (hostname == null) {
      return const Hostname('');
    }
    return Hostname(hostname);
  }

  Future<Port> get port async {
    final port = await _readKey(constants.storageKeyPort);
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
    await secureStorage.write(
      key: constants.storageKeyProtocol,
      value: protocol.value,
    );
    await secureStorage.write(
      key: constants.storageKeyHostname,
      value: hostname.value,
    );
    await secureStorage.write(
      key: constants.storageKeyPort,
      value: port.value,
    );
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
