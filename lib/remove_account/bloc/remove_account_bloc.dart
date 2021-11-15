import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/blocs/mixins.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';

part 'remove_account_event.dart';
part 'remove_account_state.dart';

class RemoveAccountBloc extends Bloc<RemoveAccountEvent, RemoveAccountState>
    with HandleResponseErrorMixin {
  RemoveAccountBloc({
    required this.authenticationBloc,
    required this.authenticationRepository,
  }) : super(const RemoveAccountState(type: RemoveAccountStateType.initial)) {
    on<RemoveAccountFormInitialized>(_onInitialized);
    on<RemoveAccountFormSubmitted>(_onSubmitted);
  }

  final AuthenticationBloc authenticationBloc;
  final AuthenticationRepository authenticationRepository;

  @override
  void onTransition(
      Transition<RemoveAccountEvent, RemoveAccountState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  void _onInitialized(
    RemoveAccountFormInitialized event,
    Emitter<RemoveAccountState> emit,
  ) {
    emit(state.clear());
  }

  void _onSubmitted(
    RemoveAccountFormSubmitted event,
    Emitter<RemoveAccountState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: RemoveAccountStateType.removingAccount));
      try {
        emit(state.copyWith(
          type: RemoveAccountStateType.removingAccountSuccess,
          message: await authenticationRepository.removeAccount(),
        ));
        emit(state.clear());
      } on DioError catch (e) {
        final responseError = handleResponseError(error: e);
        if (e.response?.statusCode == 401) {
          authenticationBloc.add(RequestSessionExpired());
          return;
        }
        emit(state.copyWith(
          type: RemoveAccountStateType.removingAccountError,
          message: responseError.message,
        ));
      }
    }
  }
}
