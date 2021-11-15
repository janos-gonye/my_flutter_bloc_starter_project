part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthenticationEvent {}

class LogoutRequested extends AuthenticationEvent {}

class ApplicationStarted extends AuthenticationEvent {}

class ApplicationResumed extends AuthenticationEvent {}

class RequestSessionExpired extends AuthenticationEvent {}

class AccountRemovalRequested extends AuthenticationEvent {}
