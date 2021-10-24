import 'package:formz/formz.dart';

enum PasswordValidationError { empty, invalidTooShort, invalidMissingRequired }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return PasswordValidationError.empty;
    if (value.length <= 8) return PasswordValidationError.invalidTooShort;
    if (RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])').hasMatch(value) == false) {
      return PasswordValidationError.invalidMissingRequired;
    }
  }

  String? get errorMessage {
    if (error == PasswordValidationError.empty) return 'Empty password';
    if (error == PasswordValidationError.invalidTooShort) {
      return 'Min 8 charachters';
    }
    if (error == PasswordValidationError.invalidMissingRequired) {
      return 'Digits, lowercase and uppercase letters required';
    }
  }
}
