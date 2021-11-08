part of 'login_bloc.dart';

enum LoginStateType {
  initial,
  data,
  loggingIn,
  loggingInSuccess,
  loggingInError,
}

class LoginState extends MyFormState<LoginStateType> {
  const LoginState({
    this.username = const Username(''),
    this.password = const Password(''),
    type = LoginStateType.initial,
    this.message = '',
  }) : super(type: type);

  final Username username;
  final Password password;
  final String message;

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
    String? message,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [username, password, type, message];
}
