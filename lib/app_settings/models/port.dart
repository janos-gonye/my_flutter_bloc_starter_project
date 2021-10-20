import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum PortValidationError {
  empty,
  invalidNotANumber,
  invalidNotAnInteger,
  invalidOutOfRange
}

class Port extends FormzInput<String, PortValidationError> {
  const Port.pure() : super.pure('');
  const Port.dirty([String value = '']) : super.dirty(value);

  @override
  PortValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PortValidationError.empty;
    } else if (isNumeric(value) == false) {
      return PortValidationError.invalidNotANumber;
    } else if (isInt(value) == false) {
      return PortValidationError.invalidNotAnInteger;
    }
    int valueInt = int.parse(value);
    if (valueInt < 1 || valueInt > 65535) {
      return PortValidationError.invalidNotANumber;
    }
  }

  String? get errorMessage {
    if (error == PortValidationError.empty) {
      return 'Empty port';
    } else if (error == PortValidationError.invalidNotANumber) {
      return 'Port is not a number';
    } else if (error == PortValidationError.invalidNotAnInteger) {
      return 'Port is not an integer';
    } else if (error == PortValidationError.invalidOutOfRange) {
      return 'Port is out-of-range';
    }
  }
}
