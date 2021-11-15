import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authenticated_home/views/views.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/change_email/change_email.dart';
import 'package:my_flutter_bloc_starter_project/change_password/bloc/change_password_bloc.dart';
import 'package:my_flutter_bloc_starter_project/home/home.dart';
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/not_found/not_found.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/password_reset.dart';
import 'package:my_flutter_bloc_starter_project/profile_settings/views/views.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';
import 'package:my_flutter_bloc_starter_project/remove_account/remove_account.dart';
import 'package:my_flutter_bloc_starter_project/shared/repositories/base_uri_configurer_repository.dart';
import 'package:my_flutter_bloc_starter_project/splash/splash.dart';
import 'package:my_flutter_bloc_starter_project/theme_selector/theme_selector.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;

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
    final authenticationBloc = AuthenticationBloc(
      authenticationRepository: authenticationRepository,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(
          create: (context) => AppSettingsBloc(
            appSettingsRepository: appSettingsRepository,
            baseURIConfigurerRepository: baseURIConfigurerRepository,
          ),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => authenticationBloc,
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
            authenticationBloc: authenticationBloc,
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ChangeEmailBloc(
            authenticationBloc: authenticationBloc,
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => RemoveAccountBloc(
            authenticationBloc: authenticationBloc,
            authenticationRepository: authenticationRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ThemeSelectorBloc(),
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
    debugPrint("'ApplicationStarted' event added to 'AuthenticationBloc'");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("'ApplicationResumed' event added to 'AuthenticationBloc'");
      BlocProvider.of<AuthenticationBloc>(context).add(ApplicationResumed());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // Store last route, so that the application can decide if navigation
  // is necessary on application resume event.
  String lastRoute = '';
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
      builder: (context, state) {
        return MaterialApp(
          theme: FlexColorScheme.light(scheme: FlexScheme.damask).toTheme,
          darkTheme: FlexColorScheme.dark(scheme: FlexScheme.damask).toTheme,
          themeMode: state.themeMode,
          navigatorKey: _navigatorKey,
          initialRoute: SplashPage.routeName,
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            AppSettingsPage.routeName: (context) => const AppSettingsPage(),
            LoginPage.routeName: (context) => const LoginPage(),
            SplashPage.routeName: (context) => const SplashPage(),
            AuthenticatedHomePage.routeName: (context) =>
                const AuthenticatedHomePage(),
            RegistrationPage.routeName: (context) => const RegistrationPage(),
            PasswordResetPage.routeName: (context) => const PasswordResetPage(),
            ProfileSettings.routeName: (context) => const ProfileSettings(),
          },
          onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(
            builder: (BuildContext context) => const NotFoundPage(),
          ),
          builder: EasyLoading.init(
            builder: (context, child) {
              return BlocListener<AuthenticationBloc, AuthenticationState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  EasyLoading.dismiss();
                  switch (state.status) {
                    case AuthenticationStatus.loggedIn:
                    case AuthenticationStatus.onAppStartStillLoggedIn:
                      _navigator.pushNamedAndRemoveUntil(
                        AuthenticatedHomePage.routeName,
                        (route) => false,
                      );
                      lastRoute = AuthenticatedHomePage.routeName;
                      break;
                    case AuthenticationStatus.loggedOut:
                    case AuthenticationStatus.onAppStartSessionExpired:
                    case AuthenticationStatus.onAppStartError:
                    case AuthenticationStatus.onAccountRemoval:
                      _navigator.pushNamedAndRemoveUntil(
                        HomePage.routeName,
                        (route) => false,
                      );
                      lastRoute = HomePage.routeName;
                      break;
                    case AuthenticationStatus.onResumeVerifying:
                      EasyLoading.show(
                        status: 'check\nauthentication...',
                        maskType: EasyLoadingMaskType.clear,
                      );
                      break;
                    case AuthenticationStatus.onRequestSessionExpired:
                      helpers.showSnackbar(context, 'Session expired');
                      _navigator.pushNamedAndRemoveUntil(
                        HomePage.routeName,
                        (route) => false,
                      );
                      lastRoute = HomePage.routeName;
                      break;
                    case AuthenticationStatus.onResumeStillLoggedIn:
                      if (lastRoute != AuthenticatedHomePage.routeName) {
                        _navigator.pushNamedAndRemoveUntil(
                          AuthenticatedHomePage.routeName,
                          (route) => false,
                        );
                        lastRoute = AuthenticatedHomePage.routeName;
                      }
                      break;
                    case AuthenticationStatus.onResumeSessionExpired:
                    case AuthenticationStatus.onResumeError:
                      if (lastRoute != HomePage.routeName) {
                        helpers.showSnackbar(context, 'Session expired');
                        _navigator.pushNamedAndRemoveUntil(
                          HomePage.routeName,
                          (route) => false,
                        );
                        lastRoute = HomePage.routeName;
                      }
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
      },
    );
  }
}
