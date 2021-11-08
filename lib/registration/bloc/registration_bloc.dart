import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/blocs/mixins.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState>
    with HandleResponseErrorMixin {
  RegistrationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegistrationState(type: RegistrationStateType.initial)) {
    on<RegistrationFormInitialized>(_onInitialized);
    on<RegistrationUsernameChanged>(_onUsernameChanged);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationPasswordConfirmChanged>(_onPasswordConfirmChanged);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationFormSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  void onTransition(
      Transition<RegistrationEvent, RegistrationState> transition) {
    debugPrint(transition.nextState.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    RegistrationFormInitialized event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.clear());
  }

  void _onUsernameChanged(
    RegistrationUsernameChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      type: RegistrationStateType.data,
      username: Username(event.username),
    ));
  }

  void _onPasswordChanged(
    RegistrationPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      password: Password(event.password),
      type: RegistrationStateType.data,
    ));
  }

  void _onPasswordConfirmChanged(
    RegistrationPasswordConfirmChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      passwordConfirm: Password(event.passwordConfirm),
      type: RegistrationStateType.data,
    ));
  }

  void _onEmailChanged(
    RegistrationEmailChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      email: Email(event.email),
      type: RegistrationStateType.data,
    ));
  }

  void _onSubmitted(
    RegistrationFormSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: RegistrationStateType.registrating));
      try {
        emit(state.copyWith(
          type: RegistrationStateType.registratingSuccess,
          message: await _authenticationRepository.registrate(
            username: state.username,
            password: state.password,
            email: state.email,
          ),
        ));
      } on DioError catch (e) {
        final responseError = handleResponseError(
          error: e,
          fields: ['username', 'password', 'email'],
        );
        final fieldErrors = responseError.fieldErrors;
        emit(state.copyWith(
          type: RegistrationStateType.registratingError,
          message: responseError.message,
          username: fieldErrors.containsKey('username')
              ? state.username.copyWith(serverError: fieldErrors['username'])
              : null,
          email: fieldErrors.containsKey('email')
              ? state.email.copyWith(serverError: fieldErrors['email'])
              : null,
          password: fieldErrors.containsKey('password')
              ? state.password.copyWith(serverError: fieldErrors['password'])
              : null,
        ));
      }
    }
  }
}
