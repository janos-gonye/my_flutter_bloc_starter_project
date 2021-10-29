import 'package:equatable/equatable.dart';

abstract class MyFormState extends Equatable {
  const MyFormState() : super();

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
