part of 'app_settings_bloc.dart';

enum AppSettingsType {
  initial,
  loading,
  loadingSuccess,
  loadingFailure,
  data,
  saving,
  savingSuccess,
  savingFailure,
}

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.protocol = const Protocol(http),
    this.hostname = const Hostname(''),
    this.port = const Port(''),
    this.type = AppSettingsType.initial,
  });

  bool get valid => protocol.valid && hostname.valid && port.valid;
  bool get invalid => !valid;

  bool get isInitial => type == AppSettingsType.initial;
  bool get isloading => type == AppSettingsType.loading;
  bool get isLoadingSuccess => type == AppSettingsType.loadingSuccess;
  bool get isLoadingFailure => type == AppSettingsType.loadingFailure;
  bool get isData => type == AppSettingsType.data;
  bool get isSaving => type == AppSettingsType.saving;
  bool get isSavingSuccess => type == AppSettingsType.savingSuccess;
  bool get isSavingFailure => type == AppSettingsType.savingFailure;

  bool get isInProgress => isInitial || isloading || isSaving;
  bool get isSuccess => isLoadingSuccess || isSavingSuccess;
  bool get isError => isLoadingFailure || isSavingFailure;

  final Protocol protocol;
  final Hostname hostname;
  final Port port;
  final AppSettingsType type;

  AppSettingsState copyWith({
    Protocol? protocol,
    Hostname? hostname,
    Port? port,
    AppSettingsType? type,
  }) {
    return AppSettingsState(
      protocol: protocol ?? this.protocol,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [port, hostname, protocol, type];
}
