import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value.isEmpty == true) {
      return EmailValidationError.empty;
    }
    if (isEmail(value) == false) {
      return EmailValidationError.invalid;
    }
  }

  String? get errorMessage {
    if (error == EmailValidationError.empty) return 'Empty email';
    if (error == EmailValidationError.invalid) return 'Invalid email';
  }
}
