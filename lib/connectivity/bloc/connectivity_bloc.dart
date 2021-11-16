import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({required this.connectivity})
      : super(const ConnectivityState(
          isInitialized: false,
          result: ConnectivityResult.none,
        )) {
    on<ConnectivityInitialized>(_onConnectivityInitialized);
    on<ConnectivityChanged>(_onConnectivityChanged);
    connectivitySubscription = connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    _initConnectivity();
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

  void _initConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        add(const ConnectivityInitialized(ConnectivityResult.mobile));
      }
    } on SocketException catch (_) {
      add(const ConnectivityInitialized(ConnectivityResult.none));
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    debugPrint("Connectivity changed: $result");
    add(ConnectivityChanged(result));
  }

  _onConnectivityInitialized(
    ConnectivityInitialized event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(ConnectivityState(result: event.result, isInitialized: true));
  }

  _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(ConnectivityState(
      result: event.result,
      isInitialized: false,
    ));
  }

  @override
  Future<void> close() {
    connectivitySubscription.cancel();
    return super.close();
  }
}
