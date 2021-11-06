part of 'registration_bloc.dart';

enum RegistrationStateType {
  initial,
  data,
  registrating,
  registratingSuccess,
  registratingError,
}

class RegistrationState extends MyFormState {
  const RegistrationState({
    this.username = const Username(''),
    this.password = const Password(''),
    this.passwordConfirm = const Password(''),
    this.email = const Email(''),
    type = RegistrationStateType.initial,
    this.message = '',
  }) : super(type: type);

  final Username username;
  final Password password;
  final Password passwordConfirm;
  final Email email;
  final String message;

  @override
  bool get valid =>
      username.valid &&
      password.valid &&
      passwordConfirm.valid &&
      email.valid &&
      password.value == passwordConfirm.value;
  @override
  bool get invalid => !valid;

  @override
  bool get isInitial => type == RegistrationStateType.initial;
  @override
  bool get isData => type == RegistrationStateType.data;
  bool get isRegistrating => type == RegistrationStateType.registrating;
  bool get isRegistratingSuccess =>
      type == RegistrationStateType.registratingSuccess;
  bool get isRegistratingError =>
      type == RegistrationStateType.registratingError;

  @override
  bool get isInProgress => isInitial || isRegistrating;
  @override
  bool get isError => isRegistratingError;
  @override
  bool get isSuccess => isRegistratingSuccess;

  @override
  RegistrationState clear() {
    return const RegistrationState();
  }

  @override
  RegistrationState copyWith({
    Username? username,
    Password? password,
    Password? passwordConfirm,
    Email? email,
    RegistrationStateType? type,
    String? message,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      email: email ?? this.email,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props =>
      [username, password, passwordConfirm, email, type, message];
}
