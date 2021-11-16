part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({
    this.result = ConnectivityResult.none,
    this.isInitialized = false,
  });

  final ConnectivityResult result;
  final bool isInitialized;

  @override
  List<Object> get props => [result, isInitialized];

  bool get isNotInitialized => !isInitialized;

  bool get isConnected => result != ConnectivityResult.none;

  bool get isNotConnected => !isConnected;
}
