part of 'login_bloc.dart';

enum LoginStateType {
  data,
  loggingIn,
  loggingInSuccess,
  loggingInError,
}

class LoginState extends Equatable {
  const LoginState({
    this.username = const Username(''),
    this.password = const Password(''),
    this.type = LoginStateType.data,
  });

  final Username username;
  final Password password;
  final LoginStateType type;

  bool get valid => username.valid && password.valid;
  bool get invalid => !valid;

  bool get isData => type == LoginStateType.data;
  bool get isLoggingIn => type == LoginStateType.loggingIn;
  bool get isLoggingInSuccess => type == LoginStateType.loggingInSuccess;
  bool get isLoggingInError => type == LoginStateType.loggingInError;

  bool get isInProgress => isLoggingIn;

  LoginState clear({LoginStateType? type}) {
    return LoginState(
      type: type ?? LoginStateType.data,
    );
  }

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
