import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({required this.connectivity})
      : super(const ConnectivityState(
          isInitializing: true,
          result: ConnectivityResult.none,
        )) {
    on<ConnectivityChanged>(_onConnectivityChanged);
    connectivitySubscription = connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onTransition(
    Transition<ConnectivityEvent, ConnectivityState> transition,
  ) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  final Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  void _updateConnectionStatus(ConnectivityResult result) {
    debugPrint("Connectivity changed: $result");
    add(ConnectivityChanged(result));
  }

  _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(ConnectivityState(result: event.result, isInitializing: false));
  }

  @override
  Future<void> close() {
    connectivitySubscription.cancel();
    return super.close();
  }
}
