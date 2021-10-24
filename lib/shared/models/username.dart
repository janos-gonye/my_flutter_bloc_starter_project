import 'package:formz/formz.dart';

enum UsernameValidationError {
  empty,
  invalidTooShort,
  invalidTooLong,
  invalidChars
}

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
    if (value.length <= 8) return UsernameValidationError.invalidTooShort;
    if (RegExp(r'^[A-Za-z0-9@.+-_]+$').hasMatch(value) == false) {
      return UsernameValidationError.invalidChars;
    }
  }

  String? get errorMessage {
    if (error == UsernameValidationError.empty) return 'Empty username';
    if (error == UsernameValidationError.invalidTooShort) {
      return '8 characters or more';
    }
    if (error == UsernameValidationError.invalidTooLong) {
      return '150 characters or fewer';
    }
    if (error == UsernameValidationError.invalidChars) {
      return 'Letters, digits and @.+-_ only';
    }
  }
}
