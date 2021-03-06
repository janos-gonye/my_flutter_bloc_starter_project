import 'package:string_validator/string_validator.dart';

import 'package:my_flutter_bloc_starter_project/shared/models/base.dart';

enum EmailValidationError { api, empty, invalid }

class Email extends FormModel<String, EmailValidationError> {
  const Email(String value, {serverError})
      : super(value, serverError: serverError);

  @override
  EmailValidationError? get error {
    if (serverError != null) {
      return EmailValidationError.api;
    }
    if (value.isEmpty == true) {
      return EmailValidationError.empty;
    }
    if (isEmail(value) == false) {
      return EmailValidationError.invalid;
    }
  }

  @override
  String? get errorMessage {
    if (error == EmailValidationError.api) return serverError;
    if (error == EmailValidationError.empty) return 'Empty email';
    if (error == EmailValidationError.invalid) return 'Invalid email';
  }

  @override
  String toString() => 'Email(serverError: $serverError)';

  @override
  Email copyWith({String? value, String? serverError}) {
    return Email(
      value ?? this.value,
      serverError: serverError ?? this.serverError,
    );
  }
}
