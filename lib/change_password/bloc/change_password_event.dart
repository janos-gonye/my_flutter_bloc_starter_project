part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordFormInitialized extends ChangePasswordEvent {
  const ChangePasswordFormInitialized();
}

class ChangePasswordCurrentPasswordChanged extends ChangePasswordEvent {
  const ChangePasswordCurrentPasswordChanged(this.currentPassword);

  final String currentPassword;

  @override
  List<Object> get props => [currentPassword];
}

class ChangePasswordNewPasswordChanged extends ChangePasswordEvent {
  const ChangePasswordNewPasswordChanged(this.newPassword);

  final String newPassword;

  @override
  List<Object> get props => [newPassword];
}

class ChangePasswordNewPasswordConfirmChanged extends ChangePasswordEvent {
  const ChangePasswordNewPasswordConfirmChanged(this.newPasswordConfirm);

  final String newPasswordConfirm;

  @override
  List<Object> get props => [newPasswordConfirm];
}

class ChangePasswordFormSubmitted extends ChangePasswordEvent {
  const ChangePasswordFormSubmitted();
}
