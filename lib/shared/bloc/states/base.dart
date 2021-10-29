import 'package:equatable/equatable.dart';

abstract class MyFormState<T> extends Equatable {
  const MyFormState({required this.type}) : super();

  final T type;

  MyFormState copyWith();

  MyFormState clear();

  bool get valid;
  bool get invalid;

  bool get isInitial;
  bool get isData;
  bool get isInProgress;
  bool get isSuccess;
  bool get isError;
}
