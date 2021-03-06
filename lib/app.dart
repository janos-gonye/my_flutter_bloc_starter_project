import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authenticated_home/views/views.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/change_email/change_email.dart';
import 'package:my_flutter_bloc_starter_project/change_password/bloc/change_password_bloc.dart';
import 'package:my_flutter_bloc_starter_project/connectivity/connectivity.dart';
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
    required this.connectivity,
  }) : super(key: key);

  final AppSettingsRepository appSettingsRepository;
  final AuthenticationRepository authenticationRepository;
  final BaseURIConfigurerRepository baseURIConfigurerRepository;
  final Connectivity connectivity;

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
        BlocProvider(
          lazy: false,
          create: (context) => ConnectivityBloc(
            connectivity: connectivity,
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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("Application life cycle state is '${state.toString()}'");
    if (state == AppLifecycleState.resumed) {
      if (isAppNotFreezed) {
        debugPrint("Application is not freezed, so it can be resumed");
        BlocProvider.of<AuthenticationBloc>(context).add(ApplicationResumed());
      } else {
        debugPrint("Application is freezed, so it cannot be resumed");
      }
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

  bool isAppStarting = true;
  bool get isNotAppStarting => !isAppStarting;

  bool isFreezedOnAppStart = false;

  bool isAppFreezed = false;
  bool get isAppNotFreezed => !isAppFreezed;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  void freezeApplication() {
    debugPrint("Freeze Application due to no connectivity");
    _navigator.pushNamed(NoConnectivityPage.routeName);
    isAppFreezed = true;
  }

  void unFreezeApplication() {
    debugPrint("Unfreeze Application since connection got created");
    if (isFreezedOnAppStart) {
      debugPrint("Application got freezed on start");
      BlocProvider.of<AuthenticationBloc>(context).add(ApplicationStarted());
    } else {
      _navigator.pop();
      debugPrint("Application didn't get freezed on start app");
      BlocProvider.of<AuthenticationBloc>(context).add(ApplicationResumed());
    }
    isFreezedOnAppStart = false;
    isAppFreezed = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeSelectorBloc, ThemeSelectorState>(
      builder: (context, state) {
        return MaterialApp(
          theme: FlexColorScheme.light(scheme: state.scheme).toTheme,
          darkTheme: FlexColorScheme.dark(scheme: state.scheme).toTheme,
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
            NotFoundPage.routeName: (context) => const NotFoundPage(),
            NoConnectivityPage.routeName: (context) =>
                const NoConnectivityPage(),
          },
          onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(
            builder: (BuildContext context) => const NotFoundPage(),
          ),
          builder: EasyLoading.init(
            builder: (context, child) {
              return MultiBlocListener(
                listeners: [
                  // Handles connectivity issues on application start
                  BlocListener<ConnectivityBloc, ConnectivityState>(
                    listenWhen: (previous, current) =>
                        isAppStarting && current.isInitialized,
                    listener: (context, state) {
                      isAppStarting = false;
                      debugPrint(
                          "Connectivity on application start: ${state.result}");
                      if (state.isConnected) {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(ApplicationStarted());
                      } else {
                        _navigator.pushNamed(NoConnectivityPage.routeName);
                        isAppFreezed = true;
                        isFreezedOnAppStart = true;
                      }
                    },
                  ),
                  // Handles connectivity issues during run
                  BlocListener<ConnectivityBloc, ConnectivityState>(
                    listenWhen: (previous, current) =>
                        isNotAppStarting &&
                        previous.isConnected != current.isConnected,
                    listener: (context, state) {
                      if (state.isNotConnected && isAppNotFreezed) {
                        freezeApplication();
                      } else if (state.isConnected && isAppFreezed) {
                        unFreezeApplication();
                      }
                    },
                  ),
                ],
                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listenWhen: (previous, current) =>
                      previous != current && !isAppFreezed,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
