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
    this.currentPassword = const Password(''),
    this.newPassword = const Password(''),
    this.newPasswordConfirm = const Password(''),
    type = ChangePasswordStateType.initial,
    this.message = '',
  }) : super(type: type);

  final Password currentPassword;
  final Password newPassword;
  final Password newPasswordConfirm;
  final String message;

  @override
  bool get valid =>
      currentPassword.valid && newPassword.valid && newPasswordConfirm.valid;
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
    Password? currentPassword,
    Password? newPassword,
    Password? newPasswordConfirm,
    ChangePasswordStateType? type,
    String? message,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      newPasswordConfirm: newPasswordConfirm ?? this.newPasswordConfirm,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props =>
      [currentPassword, newPassword, newPasswordConfirm, type, message];
}
