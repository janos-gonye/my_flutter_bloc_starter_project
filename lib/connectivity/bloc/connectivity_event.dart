part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent(this.result);

  final ConnectivityResult result;

  @override
  List<Object> get props => [result];
}

class ConnectivityInitialized extends ConnectivityEvent {
  const ConnectivityInitialized(ConnectivityResult result) : super(result);
}

class ConnectivityChanged extends ConnectivityEvent {
  const ConnectivityChanged(ConnectivityResult result) : super(result);
}
