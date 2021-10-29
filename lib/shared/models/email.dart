import 'package:string_validator/string_validator.dart';

import 'package:my_flutter_bloc_starter_project/shared/models/models.dart';

enum EmailValidationError { api, empty, invalid }

class Email extends Model<String, EmailValidationError> {
  const Email(String value, {this.apiError}) : super(value);

  final String? apiError;

  @override
  EmailValidationError? get error {
    if (apiError != null) {
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
    if (error == EmailValidationError.api) return apiError;
    if (error == EmailValidationError.empty) return 'Empty email';
    if (error == EmailValidationError.invalid) return 'Invalid email';
  }

  @override
  List<Object?> get props => super.props + [apiError];
}
