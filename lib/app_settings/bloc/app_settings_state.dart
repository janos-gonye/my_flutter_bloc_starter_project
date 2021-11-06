part of 'app_settings_bloc.dart';

enum AppSettingsStateType {
  initial,
  loading,
  loadingSuccess,
  loadingError,
  data,
  saving,
  savingSuccess,
  savingError,
}

class AppSettingsState extends MyFormState<AppSettingsStateType> {
  const AppSettingsState({
    this.protocol = const Protocol(http),
    this.hostname = const Hostname(''),
    this.port = const Port(''),
    type = AppSettingsStateType.initial,
    this.message = '',
  }) : super(type: type);

  @override
  bool get valid => protocol.valid && hostname.valid && port.valid;
  @override
  bool get invalid => !valid;

  @override
  bool get isInitial => type == AppSettingsStateType.initial;
  bool get isloading => type == AppSettingsStateType.loading;
  bool get isLoadingSuccess => type == AppSettingsStateType.loadingSuccess;
  bool get isLoadingError => type == AppSettingsStateType.loadingError;
  @override
  bool get isData => type == AppSettingsStateType.data;
  bool get isSaving => type == AppSettingsStateType.saving;
  bool get isSavingSuccess => type == AppSettingsStateType.savingSuccess;
  bool get isSavingError => type == AppSettingsStateType.savingError;

  @override
  bool get isInProgress => isInitial || isloading || isSaving;
  @override
  bool get isSuccess => isLoadingSuccess || isSavingSuccess;
  @override
  bool get isError => isLoadingError || isSavingError;

  final Protocol protocol;
  final Hostname hostname;
  final Port port;
  final String message;

  @override
  AppSettingsState clear() {
    return const AppSettingsState();
  }

  @override
  AppSettingsState copyWith({
    Protocol? protocol,
    Hostname? hostname,
    Port? port,
    AppSettingsStateType? type,
    String? message,
  }) {
    return AppSettingsState(
      protocol: protocol ?? this.protocol,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [port, hostname, protocol, type, message];
}
