import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/repositories/authentication_repository.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/password_reset.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const PasswordResetState(type: PasswordResetStateType.initial)) {
    on<PasswordResetFormInitialized>(_onInitialized);
    on<PasswordResetEmailChanged>(_onEmailChanged);
    on<PasswordResetFormSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  void onTransition(
      Transition<PasswordResetEvent, PasswordResetState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    PasswordResetFormInitialized event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(state.clear(
      type: PasswordResetStateType.initial,
    ));
  }

  void _onEmailChanged(
    PasswordResetEmailChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(state.copyWith(
      email: Email(event.email),
      type: PasswordResetStateType.data,
    ));
  }

  void _onSubmitted(
    PasswordResetFormSubmitted event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: PasswordResetStateType.passwordResetting));
      try {
        await _authenticationRepository.resetPassword(email: state.email);
        emit(state.copyWith(
          type: PasswordResetStateType.passwordResettingSuccess,
        ));
      } catch (_) {
        emit(state.copyWith(
          type: PasswordResetStateType.passwordResettingError,
        ));
      }
    }
  }
}
