import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/change_password/change_password.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/blocs/mixins.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState>
    with HandleResponseErrorMixin {
  ChangePasswordBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
            const ChangePasswordState(type: ChangePasswordStateType.initial)) {
    on<ChangePasswordFormInitialized>(_onInitialized);
    on<ChangePasswordCurrentPasswordChanged>(_onOldPasswordChanged);
    on<ChangePasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ChangePasswordNewPasswordConfirmChanged>(_onNewPasswordConfirmChanged);
    on<ChangePasswordFormSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  void onTransition(
      Transition<ChangePasswordEvent, ChangePasswordState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    ChangePasswordFormInitialized devent,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.clear());
  }

  void _onOldPasswordChanged(
    ChangePasswordCurrentPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      currentPassword: Password(event.currentPassword),
      type: ChangePasswordStateType.data,
    ));
  }

  void _onNewPasswordChanged(
    ChangePasswordNewPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      newPassword: Password(event.newPassword),
      type: ChangePasswordStateType.data,
    ));
  }

  void _onNewPasswordConfirmChanged(
    ChangePasswordNewPasswordConfirmChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(
      newPasswordConfirm: Password(event.newPasswordConfirm),
      type: ChangePasswordStateType.data,
    ));
  }

  void _onSubmitted(
    ChangePasswordFormSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: ChangePasswordStateType.passwordChanging));
      try {
        await Future.delayed(const Duration(seconds: 3));
        emit(state.copyWith(
          type: ChangePasswordStateType.passwordChangingSuccess,
          message: 'Password changed',
        ));
        emit(state.clear());
      } on DioError catch (e) {
        emit(state.copyWith(
          type: ChangePasswordStateType.passwordChangingError,
          message: e.message,
        ));
      }
    }
  }
}
