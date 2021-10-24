import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/user/user.dart';

void main() {
  runApp(
    MyStarterProjectApp(
      appSettingsRepository: const AppSettingsRepository(
        secureStorage: FlutterSecureStorage(),
      ),
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository(),
    ),
  );
}
