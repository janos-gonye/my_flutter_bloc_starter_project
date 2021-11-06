part of 'password_reset_bloc.dart';

enum PasswordResetStateType {
  initial,
  data,
  passwordResetting,
  passwordResettingSuccess,
  passwordResettingError,
}

class PasswordResetState extends MyFormState<PasswordResetStateType> {
  const PasswordResetState({
    this.email = const Email(''),
    type = PasswordResetStateType.initial,
    this.message = '',
  }) : super(type: type);

  final Email email;
  final String message;

  @override
  bool get valid => email.valid;
  @override
  bool get invalid => !valid;

  @override
  bool get isInitial => type == PasswordResetStateType.initial;
  @override
  bool get isData => type == PasswordResetStateType.data;
  bool get ispasswordResetting =>
      type == PasswordResetStateType.passwordResetting;
  bool get isPasswordResettingSuccess =>
      type == PasswordResetStateType.passwordResettingSuccess;
  bool get isPasswordResettingError =>
      type == PasswordResetStateType.passwordResettingError;

  @override
  bool get isInProgress => isInitial || ispasswordResetting;
  @override
  bool get isError => isPasswordResettingError;
  @override
  bool get isSuccess => isPasswordResettingSuccess;

  @override
  PasswordResetState clear() {
    return const PasswordResetState();
  }

  @override
  PasswordResetState copyWith({
    Email? email,
    PasswordResetStateType? type,
    String? message,
  }) {
    return PasswordResetState(
      email: email ?? this.email,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [email, type, message];
}
