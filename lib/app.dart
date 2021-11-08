import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/password_reset.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';
import 'package:my_flutter_bloc_starter_project/splash/splash.dart';
import 'package:my_flutter_bloc_starter_project/user/user.dart';

class MyStarterProjectApp extends StatefulWidget {
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
  State<MyStarterProjectApp> createState() => _MyStarterProjectAppState();
}

class _MyStarterProjectAppState extends State<MyStarterProjectApp> {
  @override
  void dispose() {
    widget.authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => widget.appSettingsRepository,
        ),
        RepositoryProvider(
          create: (context) => widget.authenticationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppSettingsBloc>(
            create: (context) => AppSettingsBloc(
              appSettingsRepository: widget.appSettingsRepository,
            ),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: widget.authenticationRepository,
              userRepository: widget.userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              authenticationRepository: widget.authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => RegistrationBloc(
              authenticationRepository: widget.authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => PasswordResetBloc(
              authenticationRepository: widget.authenticationRepository,
            ),
          ),
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
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexColorScheme.light(scheme: FlexScheme.damask).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.damask).toTheme,
      themeMode: ThemeMode.dark,
      navigatorKey: _navigatorKey,
      initialRoute: SplashPage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        AppSettingsPage.routeName: (context) => const AppSettingsPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SplashPage.routeName: (context) => const SplashPage(),
        UserPage.routeName: (context) => const UserPage(),
        RegistrationPage.routeName: (context) => const RegistrationPage(),
        PasswordResetPage.routeName: (context) => const PasswordResetPage(),
      },
      // TODO: Add 'onUnknownRoute' event

      builder: EasyLoading.init(
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              EasyLoading.dismiss();
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushNamedAndRemoveUntil(
                    UserPage.routeName,
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushNamedAndRemoveUntil(
                    HomePage.routeName,
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}
