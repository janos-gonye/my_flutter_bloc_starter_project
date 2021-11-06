import 'package:string_validator/string_validator.dart';

import 'package:my_flutter_bloc_starter_project/shared/models/base.dart';

enum PortValidationError {
  empty,
  invalidNotANumber,
  invalidNotAnInteger,
  invalidOutOfRange
}

class Port extends FormModel<String, PortValidationError> {
  const Port(String value, {serverError})
      : super(value, serverError: serverError);

  @override
  PortValidationError? get error {
    if (value.isEmpty) {
      return PortValidationError.empty;
    }
    if (isNumeric(value) == false) {
      return PortValidationError.invalidNotANumber;
    }
    if (isInt(value) == false) {
      return PortValidationError.invalidNotAnInteger;
    }
    int valueInt = int.parse(value);
    if (valueInt < 1 || valueInt > 65535) {
      return PortValidationError.invalidOutOfRange;
    }
  }

  @override
  String? get errorMessage {
    if (error == PortValidationError.empty) {
      return 'Empty port';
    }
    if (error == PortValidationError.invalidNotANumber) {
      return 'Port is not a number';
    }
    if (error == PortValidationError.invalidNotAnInteger) {
      return 'Port is not an integer';
    }
    if (error == PortValidationError.invalidOutOfRange) {
      return 'Port is out-of-range';
    }
  }

  @override
  Port copyWith({String? value, String? serverError}) {
    return Port(value ?? this.value,
        serverError: serverError ?? this.serverError);
  }
}
