part of 'app_settings_bloc.dart';

abstract class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class AppSettingsFormInitialized extends AppSettingsEvent {
  const AppSettingsFormInitialized();

  @override
  List<Object> get props => [];
}

class AppSettingsProtocolUpdated extends AppSettingsEvent {
  const AppSettingsProtocolUpdated(this.protocol);

  final String protocol;

  @override
  List<Object> get props => [protocol];
}

class AppSettingsHostnameUpdated extends AppSettingsEvent {
  const AppSettingsHostnameUpdated(this.hostname);

  final String hostname;

  @override
  List<Object> get props => [hostname];
}

class AppSettingsPortUpdated extends AppSettingsEvent {
  const AppSettingsPortUpdated(this.port);

  final String port;

  @override
  List<Object> get props => [port];
}

class AppSettingsFormSubmitted extends AppSettingsEvent {
  const AppSettingsFormSubmitted();

  @override
  List<Object> get props => [];
}
