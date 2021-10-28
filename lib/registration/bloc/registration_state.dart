part of 'registration_bloc.dart';

enum RegistrationStateType {
  initial,
  data,
  registrating,
  registratingSuccess,
  registratingError,
}

class RegistrationState extends Equatable {
  const RegistrationState({
    this.username = const Username(''),
    this.password = const Password(''),
    this.passwordConfirm = const Password(''),
    this.email = const Email(''),
    this.type = RegistrationStateType.initial,
  });

  final Username username;
  final Password password;
  final Password passwordConfirm;
  final Email email;
  final RegistrationStateType type;

  bool get valid =>
      username.valid &&
      password.valid &&
      passwordConfirm.valid &&
      email.valid &&
      password.value == passwordConfirm.value;
  bool get invalid => !valid;

  bool get isInitial => type == RegistrationStateType.initial;
  bool get isData => type == RegistrationStateType.data;
  bool get isRegistrating => type == RegistrationStateType.registrating;
  bool get isRegistratingSuccess =>
      type == RegistrationStateType.registratingSuccess;
  bool get isRegistratingError =>
      type == RegistrationStateType.registratingError;

  bool get isInProgress => isInitial || isRegistrating;

  RegistrationState copyWith({
    Username? username,
    Password? password,
    Password? passwordConfirm,
    Email? email,
    RegistrationStateType? type,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      email: email ?? this.email,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [username, password, passwordConfirm, email, type];
}
