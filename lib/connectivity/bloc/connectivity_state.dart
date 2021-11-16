part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({
    this.result = ConnectivityResult.none,
    this.isInitializing = true,
  });

  final ConnectivityResult result;
  final bool isInitializing;

  @override
  List<Object> get props => [result, isInitializing];

  bool get isNotInitializing => !isInitializing;

  bool get isConnected => result != ConnectivityResult.none;

  bool get isNotConnected => !isConnected;
}
