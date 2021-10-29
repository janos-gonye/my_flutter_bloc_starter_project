import 'package:equatable/equatable.dart';

abstract class Model<T, E> extends Equatable {
  const Model(this.value);

  final T value;

  bool get valid {
    if (error == null) return true;
    return false;
  }

  bool get invalid {
    if (error == null) return false;
    return true;
  }

  E? get error;

  String? get errorMessage;

  @override
  String toString() {
    return "${runtimeType.toString()}(value: ${value.toString()})";
  }

  @override
  List<Object?> get props => [value, error];
}
