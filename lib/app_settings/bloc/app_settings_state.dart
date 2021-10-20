part of 'app_settings_bloc.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.formStatus = FormzStatus.pure,
    this.protocol = const Protocol.pure(),
    this.hostname = const Hostname.pure(),
    this.port = const Port.pure(),
    this.fetching = false,
  }) : super();

  final FormzStatus formStatus;
  final Protocol protocol;
  final Hostname hostname;
  final Port port;
  final bool fetching;

  AppSettingsState copyWith({
    FormzStatus? formStatus,
    Protocol? protocol,
    Hostname? hostname,
    Port? port,
    bool? fetching,
  }) {
    return AppSettingsState(
      formStatus: formStatus ?? this.formStatus,
      protocol: protocol ?? this.protocol,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      fetching: fetching ?? this.fetching,
    );
  }

  @override
  List<Object> get props => [fetching, formStatus, port, hostname, protocol];
}
