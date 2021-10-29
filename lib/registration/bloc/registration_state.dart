part of 'registration_bloc.dart';

enum RegistrationStateType {
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
    this.type = RegistrationStateType.data,
    this.message = '',
  });

  final Username username;
  final Password password;
  final Password passwordConfirm;
  final Email email;
  final RegistrationStateType type;
  final String message;

  bool get valid =>
      username.valid &&
      password.valid &&
      passwordConfirm.valid &&
      email.valid &&
      password.value == passwordConfirm.value;
  bool get invalid => !valid;

  bool get isData => type == RegistrationStateType.data;
  bool get isRegistrating => type == RegistrationStateType.registrating;
  bool get isRegistratingSuccess =>
      type == RegistrationStateType.registratingSuccess;
  bool get isRegistratingError =>
      type == RegistrationStateType.registratingError;

  bool get isInProgress => isRegistrating;

  RegistrationState clear({RegistrationStateType? type}) {
    return RegistrationState(
      type: type ?? RegistrationStateType.data,
    );
  }

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

  RegistrationState stateFormServerError({
    RegistrationStateType? type,
    String? message,
    required Map<String, List<dynamic>> errors,
  }) {
    return copyWith(
      type: type,
      message: message,
      username: errors.containsKey('username')
          ? Username(
              username.value,
              serverError: errors['username']?.first.toString(),
            )
          : null,
      password: errors.containsKey('password')
          ? Password(
              password.value,
              serverError: errors['password']?.first.toString(),
            )
          : null,
      email: errors.containsKey('email')
          ? Email(
              email.value,
              serverError: errors['email']?.first.toString(),
            )
          : null,
    );
  }

  @override
  List<Object> get props =>
      [username, password, passwordConfirm, email, type, message];
}
