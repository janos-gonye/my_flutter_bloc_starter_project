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
    required this.authenticationBloc,
    required this.authenticationRepository,
  }) : super(const ChangePasswordState(type: ChangePasswordStateType.initial)) {
    on<ChangePasswordFormInitialized>(_onInitialized);
    on<ChangePasswordCurrentPasswordChanged>(_onOldPasswordChanged);
    on<ChangePasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ChangePasswordNewPasswordConfirmChanged>(_onNewPasswordConfirmChanged);
    on<ChangePasswordFormSubmitted>(_onSubmitted);
  }

  final AuthenticationBloc authenticationBloc;
  final AuthenticationRepository authenticationRepository;

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
        emit(state.copyWith(
          type: ChangePasswordStateType.passwordChangingSuccess,
          message: await authenticationRepository.changePassword(
            currentPassword: state.currentPassword,
            newPassword: state.newPassword,
          ),
        ));
        emit(state.clear());
      } on DioError catch (e) {
        final responseError = handleResponseError(
          error: e,
          fields: ['current_password', 'new_password'],
        );
        final fieldErrors = responseError.fieldErrors;
        if (e.response?.statusCode == 401) {
          authenticationBloc.add(RequestSessionExpired());
          return;
        }
        emit(state.copyWith(
          type: ChangePasswordStateType.passwordChangingError,
          message: responseError.message,
          currentPassword: fieldErrors.containsKey('current_password')
              ? state.currentPassword
                  .copyWith(serverError: fieldErrors['current_password'])
              : null,
          newPassword: fieldErrors.containsKey('new_password')
              ? state.newPassword
                  .copyWith(serverError: fieldErrors['new_password'])
              : null,
        ));
      }
    }
  }
}
