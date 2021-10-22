import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/splash/splash.dart';
import 'package:my_flutter_bloc_starter_project/user/user.dart';

class MyStarterProjectApp extends StatelessWidget {
  const MyStarterProjectApp({
    Key? key,
    required this.appSettingsRepository,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AppSettingsRepository appSettingsRepository;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => appSettingsRepository,
        ),
        RepositoryProvider(
          create: (context) => authenticationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingsBloc>(
            create: (context) => AppSettingsBloc(
              appSettingsRepository: appSettingsRepository,
            ),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userRepository: userRepository,
            ),
          )
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        AppSettingsPage.routeName: (context) => const AppSettingsPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SplashPage.routeName: (context) => const SplashPage(),
      },
    );
  }
}
