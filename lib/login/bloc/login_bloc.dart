import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/repositories/authentication_repository.dart';
import 'package:my_flutter_bloc_starter_project/login/models/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState(type: LoginStateType.initial)) {
    on<LoginFormInitialized>(_onInitialized);
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginFormSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    LoginFormInitialized event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      type: LoginStateType.data,
    ));
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      username: Username(event.username),
      type: LoginStateType.data,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: Password(event.password),
      type: LoginStateType.data,
    ));
  }

  void _onSubmitted(
    LoginFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: LoginStateType.loggingIn));
      try {
        await _authenticationRepository.logIn(
          username: state.username,
          password: state.password,
        );
        emit(state.copyWith(type: LoginStateType.loggingInSuccess));
      } catch (_) {
        emit(state.copyWith(type: LoginStateType.loggingInError));
      }
    }
  }
}
