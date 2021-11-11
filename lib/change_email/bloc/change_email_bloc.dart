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
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const ChangeEmailState(type: ChangeEmailStateType.initial)) {
    on<ChangeEmailFormInitialized>(_onInitialized);
    on<ChangeEmailEmailChanged>(_onEmailChanged);
    on<ChangeEmailEmailConfirmChanged>(_onEmailConfirmChanged);
    on<ChangeEmailFormSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

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
        await Future.delayed(const Duration(seconds: 3));
        emit(state.copyWith(
          type: ChangeEmailStateType.emailChangingSuccess,
          message: 'Email changed',
        ));
        emit(state.clear());
      } on DioError catch (e) {
        emit(state.copyWith(
          type: ChangeEmailStateType.emailChangingError,
          message: e.message,
        ));
      }
    }
  }
}
