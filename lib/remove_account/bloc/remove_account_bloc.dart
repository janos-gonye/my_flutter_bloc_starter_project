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
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RemoveAccountState(type: RemoveAccountStateType.initial)) {
    on<RemoveAccountFormInitialized>(_onInitialized);
    on<RemoveAccountFormSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

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
          message: await _authenticationRepository.removeAccount(),
        ));
        emit(state.clear());
      } on DioError catch (e) {
        final responseError = handleResponseError(error: e);
        emit(state.copyWith(
          type: RemoveAccountStateType.removingAccountError,
          message: responseError.message,
        ));
      }
    }
  }
}
