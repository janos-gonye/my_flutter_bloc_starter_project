part of 'password_reset_bloc.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class PasswordResetFormInitialized extends PasswordResetEvent {
  const PasswordResetFormInitialized();
}

class PasswordResetEmailChanged extends PasswordResetEvent {
  const PasswordResetEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordResetFormSubmitted extends PasswordResetEvent {
  const PasswordResetFormSubmitted();
}
