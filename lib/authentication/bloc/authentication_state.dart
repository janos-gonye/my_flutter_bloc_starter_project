part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  unknown,

  loggedIn,
  loggedOut,

  onAppStartStillLoggedIn,
  onAppStartSessionExpired,

  onRequestSessionExpired,

  onResumeVerifying,
  onResumeVerifyStillLoggedIn,
  onResumeVerifySessionExpired,
  onResumseVerifyingError,
}

class AuthenticationState extends Equatable {
  const AuthenticationState(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
