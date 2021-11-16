part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({this.result = ConnectivityResult.none});

  final ConnectivityResult result;

  @override
  List<Object> get props => [result];
}
