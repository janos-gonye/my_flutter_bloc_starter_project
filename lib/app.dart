import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/change_email/change_email.dart';
import 'package:my_flutter_bloc_starter_project/change_password/bloc/change_password_bloc.dart';
import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/password_reset.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';
import 'package:my_flutter_bloc_starter_project/remove_account/remove_account.dart';
import 'package:my_flutter_bloc_starter_project/shared/repositories/base_uri_configurer_repository.dart';
import 'package:my_flutter_bloc_starter_project/splash/splash.dart';
import 'package:my_flutter_bloc_starter_project/user/user.dart';

class MyStarterProjectApp extends StatelessWidget {
  const MyStarterProjectApp({
    Key? key,
    required this.appSettingsRepository,
    required this.authenticationRepository,
    required this.baseURIConfigurerRepository,
  }) : super(key: key);

  final AppSettingsRepository appSettingsRepository;
  final AuthenticationRepository authenticationRepository;
  final BaseURIConfigurerRepository baseURIConfigurerRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(
          create: (context) => AppSettingsBloc(
            appSettingsRepository: appSettingsRepository,
            baseURIConfigurerRepository: baseURIConfigurerRepository,
          ),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => RegistrationBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PasswordResetBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ChangePasswordBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ChangeEmailBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => RemoveAccountBloc(
            authenticationRepository: authenticationRepository,
          ),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    BlocProvider.of<AuthenticationBloc>(context).add(ApplicationStarted());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<AuthenticationBloc>(context).add(ApplicationResumed());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

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
