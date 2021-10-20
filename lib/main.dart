import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/repositories/app_settings_repository.dart';

void main() {
  runApp(const MyStarterProjectApp(
    appSettingsRepository:
        AppSettingsRepository(secureStorage: FlutterSecureStorage()),
  ));
}
