import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegistrationState(type: RegistrationStateType.data)) {
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
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    RegistrationFormInitialized event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.clear(type: RegistrationStateType.data));
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
        final successMessage = await _authenticationRepository.registrate(
          username: state.username,
          password: state.password,
          email: state.email,
        );
        emit(state.copyWith(
          type: RegistrationStateType.registratingSuccess,
          message: successMessage,
        ));
      } on DioError catch (e) {
        if (e.response != null &&
            e.response?.statusCode == 400 &&
            e.response?.data != null) {
          final errors = Map<String, List<dynamic>>.from(e.response!.data);
          emit(
            state.stateFormServerError(
              type: RegistrationStateType.registratingError,
              message: 'invalid values',
              errors: errors,
            ),
          );
        } else {
          emit(state.copyWith(
            type: RegistrationStateType.registratingError,
            message: e.response!.data.toString(),
          ));
        }
      }
    }
  }
}
