import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/change_email/change_email.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/blocs/mixins.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

part 'change_email_event.dart';
part 'change_email_state.dart';

class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState>
    with HandleResponseErrorMixin {
  ChangeEmailBloc({
    required this.authenticationBloc,
    required this.authenticationRepository,
  }) : super(const ChangeEmailState(type: ChangeEmailStateType.initial)) {
    on<ChangeEmailFormInitialized>(_onInitialized);
    on<ChangeEmailEmailChanged>(_onEmailChanged);
    on<ChangeEmailEmailConfirmChanged>(_onEmailConfirmChanged);
    on<ChangeEmailFormSubmitted>(_onSubmitted);
  }

  final AuthenticationBloc authenticationBloc;
  final AuthenticationRepository authenticationRepository;

  @override
  void onTransition(Transition<ChangeEmailEvent, ChangeEmailState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    ChangeEmailFormInitialized devent,
    Emitter<ChangeEmailState> emit,
  ) {
    emit(state.clear());
  }

  void _onEmailChanged(
    ChangeEmailEmailChanged event,
    Emitter<ChangeEmailState> emit,
  ) {
    emit(state.copyWith(
      email: Email(event.email),
      type: ChangeEmailStateType.data,
    ));
  }

  void _onEmailConfirmChanged(
    ChangeEmailEmailConfirmChanged event,
    Emitter<ChangeEmailState> emit,
  ) {
    emit(state.copyWith(
      emailConfirm: Email(event.emailConfirm),
      type: ChangeEmailStateType.data,
    ));
  }

  void _onSubmitted(
    ChangeEmailFormSubmitted event,
    Emitter<ChangeEmailState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: ChangeEmailStateType.emailChanging));
      try {
        emit(state.copyWith(
          type: ChangeEmailStateType.emailChangingSuccess,
          message: await authenticationRepository.changeEmail(
            email: state.email,
          ),
        ));
        emit(state.clear());
      } on DioError catch (e) {
        final responseError = handleResponseError(error: e, fields: ['email']);
        final fieldErrors = responseError.fieldErrors;
        if (e.response?.statusCode == 401) {
          authenticationBloc.add(RequestSessionExpired());
          return;
        }
        emit(state.copyWith(
          type: ChangeEmailStateType.emailChangingError,
          message: responseError.message,
          email: fieldErrors.containsKey('email')
              ? state.email.copyWith(serverError: fieldErrors['email'])
              : null,
        ));
      }
    }
  }
}
