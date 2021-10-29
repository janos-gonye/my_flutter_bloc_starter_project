import 'package:my_flutter_bloc_starter_project/shared/models/models.dart';

enum PasswordValidationError {
  api,
  empty,
  invalidTooShort,
  invalidMissingRequired,
}

class Password extends Model<String, PasswordValidationError> {
  const Password(String value, {this.apiError}) : super(value);

  final String? apiError;

  @override
  PasswordValidationError? get error {
    if (apiError != null) return PasswordValidationError.api;
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length <= 8) return PasswordValidationError.invalidTooShort;
    if (RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])').hasMatch(value) == false) {
      return PasswordValidationError.invalidMissingRequired;
    }
  }

  @override
  String? get errorMessage {
    if (error == PasswordValidationError.api) return apiError;
    if (error == PasswordValidationError.empty) return 'Empty password';
    if (error == PasswordValidationError.invalidTooShort) {
      return 'Min 8 charachters';
    }
    if (error == PasswordValidationError.invalidMissingRequired) {
      return 'Digits, lowercase and uppercase letters required';
    }
  }

  @override
  List<Object?> get props => super.props + [apiError];
}