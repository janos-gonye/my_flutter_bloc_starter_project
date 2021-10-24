part of 'registration_bloc.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.email = const Email.pure(),
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final Email email;

  RegistrationState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    Email? email,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [status, username, password, email];
}
