part of 'app_settings_bloc.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object> get props => [];
}

class AppSettingsLoadingState extends AppSettingsState {}

class AppSettingsDataState extends AppSettingsState {
  const AppSettingsDataState({
    this.formStatus = FormzStatus.pure,
    this.protocol = const Protocol.pure(),
    this.hostname = const Hostname.pure(),
    this.port = const Port.pure(),
  }) : super();

  final FormzStatus formStatus;
  final Protocol protocol;
  final Hostname hostname;
  final Port port;

  AppSettingsDataState copyWith({
    FormzStatus? formStatus,
    Protocol? protocol,
    Hostname? hostname,
    Port? port,
  }) {
    return AppSettingsDataState(
      formStatus: formStatus ?? this.formStatus,
      protocol: protocol ?? this.protocol,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
    );
  }

  @override
  List<Object> get props => [formStatus, port, hostname, protocol];
}
