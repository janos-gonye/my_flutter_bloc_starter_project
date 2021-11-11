part of 'change_email_bloc.dart';

abstract class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}

class ChangeEmailFormInitialized extends ChangeEmailEvent {
  const ChangeEmailFormInitialized();
}

class ChangeEmailEmailChanged extends ChangeEmailEvent {
  const ChangeEmailEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ChangeEmailEmailConfirmChanged extends ChangeEmailEvent {
  const ChangeEmailEmailConfirmChanged(this.emailConfirm);

  final String emailConfirm;

  @override
  List<Object> get props => [emailConfirm];
}

class ChangeEmailFormSubmitted extends ChangeEmailEvent {
  const ChangeEmailFormSubmitted();
}
