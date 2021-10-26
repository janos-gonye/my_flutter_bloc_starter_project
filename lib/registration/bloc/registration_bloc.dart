import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    required RegistrationRepository registrationRepository,
  })  : _registrationRepository = registrationRepository,
        super(const RegistrationState(type: RegistrationStateType.initial)) {
    on<RegistrationFormInitialized>(_onInitialized);
    on<RegistrationUsernameChanged>(_onUsernameChanged);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationFormSubmitted>(_onSubmitted);
  }

  final RegistrationRepository _registrationRepository;

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
    emit(state.copyWith(
      type: RegistrationStateType.initial,
    ));
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
        await _registrationRepository.registrate(
          username: state.username,
          password: state.password,
          email: state.email,
        );
        emit(state.copyWith(type: RegistrationStateType.registratingSuccess));
      } catch (_) {
        emit(state.copyWith(type: RegistrationStateType.registratingError));
      }
    }
  }
}
