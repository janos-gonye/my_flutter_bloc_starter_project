import 'package:string_validator/string_validator.dart';

import 'package:my_flutter_bloc_starter_project/shared/models/models.dart';

enum EmailValidationError { empty, invalid }

class Email extends Model<String, EmailValidationError> {
  const Email(String value) : super(value);

  @override
  EmailValidationError? get error {
    if (value.isEmpty == true) {
      return EmailValidationError.empty;
    }
    if (isEmail(value) == false) {
      return EmailValidationError.invalid;
    }
  }

  @override
  String? get errorMessage {
    if (error == EmailValidationError.empty) return 'Empty email';
    if (error == EmailValidationError.invalid) return 'Invalid email';
  }
}
