part of 'change_password_bloc.dart';

enum ChangePasswordStateType {
  initial,
  data,
  passwordChanging,
  passwordChangingSuccess,
  passwordChangingError,
}

class ChangePasswordState extends MyFormState<ChangePasswordStateType> {
  const ChangePasswordState({
    this.password = const Password(''),
    this.passwordConfirm = const Password(''),
    type = ChangePasswordStateType.initial,
    this.message = '',
  }) : super(type: type);

  final Password password;
  final Password passwordConfirm;
  final String message;

  @override
  bool get valid => password.valid && passwordConfirm.valid;
  @override
  bool get invalid => !valid;

  @override
  bool get isInitial => type == ChangePasswordStateType.initial;
  @override
  bool get isData => type == ChangePasswordStateType.data;
  bool get isPasswordChanging =>
      type == ChangePasswordStateType.passwordChanging;
  bool get isPasswordChangingSuccess =>
      type == ChangePasswordStateType.passwordChangingSuccess;
  bool get isPasswordChangingError =>
      type == ChangePasswordStateType.passwordChangingError;

  @override
  bool get isInProgress => isInitial || isPasswordChanging;
  @override
  bool get isError => isPasswordChangingError;
  @override
  bool get isSuccess => isPasswordChangingSuccess;

  @override
  ChangePasswordState clear() {
    return const ChangePasswordState();
  }

  @override
  ChangePasswordState copyWith({
    Password? password,
    Password? passwordConfirm,
    ChangePasswordStateType? type,
    String? message,
  }) {
    return ChangePasswordState(
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [password, passwordConfirm, type, message];
}
