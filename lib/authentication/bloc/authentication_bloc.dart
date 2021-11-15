import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ApplicationStarted>(_onApplicationStarted);
    on<ApplicationResumed>(_onApplicationResumed);
    on<AccountRemovalRequested>(_onAccountRemovalRequested);
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  void onTransition(
    Transition<AuthenticationEvent, AuthenticationState> transition,
  ) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onLoginRequested(
    LoginRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.loggedIn());
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
    emit(const AuthenticationState.loggedOut());
  }

  void _onApplicationStarted(
    ApplicationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      if (await _authenticationRepository.tokenVerify()) {
        emit(const AuthenticationState.onAppStartStillLoggedIn());
      } else {
        _authenticationRepository.clearTokens();
        emit(const AuthenticationState.onAppStartSessionExpired());
      }
    } on DioError catch (_) {
      _authenticationRepository.clearTokens();
      emit(const AuthenticationState.onAppStartError());
    }
  }

  void _onApplicationResumed(
    ApplicationResumed event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(const AuthenticationState.onResumeVerifying());
      if (await _authenticationRepository.tokenVerify()) {
        emit(const AuthenticationState.onResumeVerifyStillLoggedIn());
      } else {
        _authenticationRepository.clearTokens();
        emit(const AuthenticationState.onResumeVerifySessionExpired());
      }
    } on DioError catch (_) {
      _authenticationRepository.clearTokens();
      emit(const AuthenticationState.onResumeVerifyingError());
    }
  }

  void _onAccountRemovalRequested(
    AccountRemovalRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.onAccountRemoval());
  }
}
