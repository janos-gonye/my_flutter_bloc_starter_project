import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/repositories/authentication_repository.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/password_reset.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/blocs/mixins.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState>
    with HandleResponseErrorMixin {
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
    emit(state.clear());
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
        emit(state.copyWith(
          type: PasswordResetStateType.passwordResettingSuccess,
          message: await _authenticationRepository.resetPassword(
            email: state.email,
          ),
        ));
      } on DioError catch (e) {
        final responseError = handleResponseError(
          error: e,
          fields: ['email'],
        );
        final fieldErrors = responseError.fieldErrors;
        emit(state.copyWith(
          type: PasswordResetStateType.passwordResettingError,
          message: responseError.message,
          email: fieldErrors.containsKey('email')
              ? state.email.copyWith(serverError: fieldErrors['email'])
              : null,
        ));
      }
    }
  }
}
