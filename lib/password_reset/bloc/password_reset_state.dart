part of 'password_reset_bloc.dart';

enum PasswordResetStateType {
  data,
  passwordResetting,
  passwordResettingSuccess,
  passwordResettingError,
}

class PasswordResetState extends Equatable {
  const PasswordResetState({
    this.email = const Email(''),
    this.type = PasswordResetStateType.data,
  });

  final Email email;
  final PasswordResetStateType type;

  bool get valid => email.valid;
  bool get invalid => !valid;

  bool get isData => type == PasswordResetStateType.data;
  bool get ispasswordResetting =>
      type == PasswordResetStateType.passwordResetting;
  bool get isPasswordResettingSuccess =>
      type == PasswordResetStateType.passwordResettingSuccess;
  bool get isPasswordResettingError =>
      type == PasswordResetStateType.passwordResettingError;

  bool get isInProgress => ispasswordResetting;

  PasswordResetState clear({PasswordResetStateType? type}) {
    return PasswordResetState(
      type: type ?? PasswordResetStateType.data,
    );
  }

  PasswordResetState copyWith({
    Email? email,
    PasswordResetStateType? type,
  }) {
    return PasswordResetState(
      email: email ?? this.email,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [email, type];
}
