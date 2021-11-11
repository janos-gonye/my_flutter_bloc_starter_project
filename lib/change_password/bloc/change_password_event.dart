part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordFormInitialized extends ChangePasswordEvent {
  const ChangePasswordFormInitialized();
}

class ChangePasswordPasswordChanged extends ChangePasswordEvent {
  const ChangePasswordPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class ChangePasswordPasswordConfirmChanged extends ChangePasswordEvent {
  const ChangePasswordPasswordConfirmChanged(this.passwordConfirm);

  final String passwordConfirm;

  @override
  List<Object> get props => [passwordConfirm];
}

class ChangePasswordFormSubmitted extends ChangePasswordEvent {
  const ChangePasswordFormSubmitted();
}
