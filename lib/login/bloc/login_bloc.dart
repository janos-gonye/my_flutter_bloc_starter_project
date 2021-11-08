import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/repositories/authentication_repository.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/login/models/models.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/blocs/mixins.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>
    with HandleResponseErrorMixin {
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
    emit(state.clear());
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
        emit(state.copyWith(
          type: LoginStateType.loggingInSuccess,
          message: await _authenticationRepository.logIn(
            username: state.username,
            password: state.password,
          ),
        ));
      } on DioError catch (e) {
        final responseError = handleResponseError(error: e, fields: [
          'username',
          'password',
        ]);
        String message;
        if (responseError.dioError.response?.statusCode == 401) {
          message = responseError
              .dioError.response?.data[constants.apiResponseMessageKey];
        } else {
          message = responseError.message;
        }
        emit(state.copyWith(
          type: LoginStateType.loggingInError,
          message: message,
        ));
      }
    }
  }
}
