import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart';
import 'package:my_flutter_bloc_starter_project/shared/bloc/states/base.dart';
import 'package:my_flutter_bloc_starter_project/shared/repositories/base_uri_configurer_repository.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc({
    required this.appSettingsRepository,
    required this.baseURIConfigurerRepository,
  }) : super(const AppSettingsState()) {
    on<AppSettingsFormInitialized>(_onInitialized);
    on<AppSettingsProtocolUpdated>(_onProtocolChanged);
    on<AppSettingsHostnameUpdated>(_onHostnameChanged);
    on<AppSettingsPortUpdated>(_onPortChanged);
    on<AppSettingsFormSubmitted>(_onFormSubmitted);
  }

  final AppSettingsRepository appSettingsRepository;
  final BaseURIConfigurerRepository baseURIConfigurerRepository;

  @override
  void onTransition(Transition<AppSettingsEvent, AppSettingsState> transition) {
    debugPrint(transition.toString());
    super.onTransition(transition);
  }

  _onInitialized(
    AppSettingsFormInitialized event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.clear());
    emit(state.copyWith(type: AppSettingsStateType.loading));
    try {
      Protocol? protocol = await appSettingsRepository.protocol;
      Hostname? hostname = await appSettingsRepository.hostname;
      Port? port = await appSettingsRepository.port;
      protocol ??= Protocol(protocol!.value);
      hostname ??= Hostname(hostname!.value);
      port ??= Port(port!.value);
      emit(state.copyWith(
        type: AppSettingsStateType.loadingSuccess,
        protocol: protocol,
        hostname: hostname,
        port: port,
      ));
    } catch (_) {
      emit(state.copyWith(type: AppSettingsStateType.loadingError));
    }
  }

  _onHostnameChanged(
    AppSettingsHostnameUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(state.copyWith(
      type: AppSettingsStateType.data,
      hostname: Hostname(event.hostname),
    ));
  }

  _onProtocolChanged(
    AppSettingsProtocolUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(state.copyWith(
      type: AppSettingsStateType.data,
      protocol: Protocol(event.protocol),
    ));
  }

  _onPortChanged(
    AppSettingsPortUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(state.copyWith(
      type: AppSettingsStateType.data,
      port: Port(event.port),
    ));
  }

  _onFormSubmitted(
    AppSettingsFormSubmitted event,
    Emitter<AppSettingsState> emit,
  ) async {
    if (state.valid) {
      emit(state.copyWith(type: AppSettingsStateType.saving));
      try {
        await appSettingsRepository.write(
          hostname: state.hostname,
          protocol: state.protocol,
          port: state.port,
        );
        await baseURIConfigurerRepository.reloadBaseURI();
        emit(state.copyWith(
          type: AppSettingsStateType.savingSuccess,
          message: 'Settings saved',
        ));
      } catch (_) {
        emit(state.copyWith(
          type: AppSettingsStateType.savingError,
          message: 'Saving settings failed',
        ));
      }
    }
  }
}
