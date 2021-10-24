import 'package:formz/formz.dart';

enum UsernameValidationError { empty, invalidTooLong, invalidChars }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError? validator(String? value) {
    if (value == null || value.isEmpty == true) {
      return UsernameValidationError.empty;
    }
    if (value.length >= 150) {
      return UsernameValidationError.invalidTooLong;
    }
    if (RegExp(r'^[A-Za-z0-9@.+-_]+$').hasMatch(value) == false) {
      return UsernameValidationError.invalidChars;
    }
  }

  String? get errorMessage {
    if (error == UsernameValidationError.empty) return 'Empty username';
    if (error == UsernameValidationError.invalidTooLong) {
      return 'Max 150 characters of fewer';
    }
    if (error == UsernameValidationError.invalidChars) {
      return 'Letters, digits and @.+-_ only';
    }
  }
}
