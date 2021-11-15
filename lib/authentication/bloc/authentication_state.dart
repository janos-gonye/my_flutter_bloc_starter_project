part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  unknown,

  loggedIn,
  loggedOut,

  onAppStartStillLoggedIn,
  onAppStartSessionExpired,
  onAppStartError,

  onRequestSessionExpired,

  onAccountRemoval,

  onResumeVerifying,
  onResumeStillLoggedIn,
  onResumeSessionExpired,
  onResumeError,
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
  }) : super();

  const AuthenticationState.unknown()
      : this._(status: AuthenticationStatus.unknown);

  const AuthenticationState.loggedIn()
      : this._(status: AuthenticationStatus.loggedIn);

  const AuthenticationState.loggedOut()
      : this._(status: AuthenticationStatus.loggedOut);

  const AuthenticationState.onAppStartStillLoggedIn()
      : this._(status: AuthenticationStatus.onAppStartStillLoggedIn);

  const AuthenticationState.onAppStartSessionExpired()
      : this._(status: AuthenticationStatus.onAppStartSessionExpired);

  const AuthenticationState.onAppStartError()
      : this._(status: AuthenticationStatus.onAppStartError);

  const AuthenticationState.onRequestSessionExpired()
      : this._(status: AuthenticationStatus.onRequestSessionExpired);

  const AuthenticationState.onResumeVerifying()
      : this._(status: AuthenticationStatus.onResumeVerifying);

  const AuthenticationState.onResumeVerifyStillLoggedIn()
      : this._(status: AuthenticationStatus.onResumeStillLoggedIn);

  const AuthenticationState.onResumeVerifySessionExpired()
      : this._(status: AuthenticationStatus.onResumeSessionExpired);

  const AuthenticationState.onResumeVerifyingError()
      : this._(status: AuthenticationStatus.onResumeError);

  const AuthenticationState.onAccountRemoval()
      : this._(status: AuthenticationStatus.onAccountRemoval);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
