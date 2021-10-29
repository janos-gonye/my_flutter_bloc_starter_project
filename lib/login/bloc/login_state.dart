part of 'login_bloc.dart';

enum LoginStateType {
  initial,
  data,
  loggingIn,
  loggingInSuccess,
  loggingInError,
}

class LoginState extends MyFormState {
  const LoginState({
    this.username = const Username(''),
    this.password = const Password(''),
    this.type = LoginStateType.initial,
  });

  final Username username;
  final Password password;
  final LoginStateType type;

  @override
  bool get valid => username.valid && password.valid;
  @override
  bool get invalid => !valid;

  @override
  bool get isInitial => type == LoginStateType.initial;
  @override
  bool get isData => type == LoginStateType.data;
  bool get isLoggingIn => type == LoginStateType.loggingIn;
  bool get isLoggingInSuccess => type == LoginStateType.loggingInSuccess;
  bool get isLoggingInError => type == LoginStateType.loggingInError;

  @override
  bool get isInProgress => isInitial || isLoggingIn;
  @override
  bool get isError => isLoggingInError;
  @override
  bool get isSuccess => isLoggingInSuccess;

  @override
  LoginState clear() {
    return const LoginState();
  }

  @override
  LoginState copyWith({
    Username? username,
    Password? password,
    LoginStateType? type,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [username, password, type];
}
