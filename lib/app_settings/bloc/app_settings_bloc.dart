import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc({required this.appSettingsRepository})
      : super(const AppSettingsState()) {
    on<AppSettingsInitialized>(_onInitialized);
    on<AppSettingsProtocolUpdated>(_onProtocolChanged);
    on<AppSettingsHostnameUpdated>(_onHostnameChanged);
    on<AppSettingsPortUpdated>(_onPortChanged);
    on<AppSettingsFormSubmitted>(_onFormSubmitted);
  }

  final AppSettingsRepository appSettingsRepository;

  _onInitialized(
    AppSettingsInitialized event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.copyWith(fetching: true));
    await Future.delayed(const Duration(seconds: 2));
    final protocol = await appSettingsRepository.protocol;
    final hostname = await appSettingsRepository.hostname;
    final port = await appSettingsRepository.port;
    emit(state.copyWith(
      fetching: false,
      protocol: protocol,
      hostname: hostname,
      port: port,
      formStatus: Formz.validate([protocol, hostname, port]),
    ));
  }

  _onHostnameChanged(
    AppSettingsHostnameUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    final hostname = Hostname.dirty(event.hostname);
    emit(state.copyWith(
      hostname: hostname,
      formStatus: Formz.validate([state.protocol, hostname, state.port]),
    ));
  }

  _onProtocolChanged(
    AppSettingsProtocolUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    if (state is AppSettingsState) {
      final protocol = Protocol.dirty(event.protocol);
      emit(state.copyWith(
        protocol: protocol,
        formStatus: Formz.validate([protocol, state.hostname, state.port]),
      ));
    }
  }

  _onPortChanged(
    AppSettingsPortUpdated event,
    Emitter<AppSettingsState> emit,
  ) {
    final port = Port.dirty(event.port);
    emit(state.copyWith(
      port: port,
      formStatus: Formz.validate([state.protocol, state.hostname, port]),
    ));
  }

  _onFormSubmitted(
    AppSettingsFormSubmitted event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormzStatus.submissionInProgress,
    ));
    try {
      await appSettingsRepository.write(
        hostname: state.hostname,
        protocol: state.protocol,
        port: state.port,
      );
      emit(state.copyWith(formStatus: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }
}
