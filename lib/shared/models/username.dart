import 'package:my_flutter_bloc_starter_project/shared/models/base.dart';

enum UsernameValidationError {
  api,
  empty,
  invalidTooShort,
  invalidTooLong,
  invalidChars
}

class Username extends FormModel<String, UsernameValidationError> {
  const Username(String value, {serverError})
      : super(value, serverError: serverError);

  @override
  UsernameValidationError? get error {
    if (serverError != null) return UsernameValidationError.api;
    if (value.isEmpty == true) {
      return UsernameValidationError.empty;
    }
    if (value.length >= 150) {
      return UsernameValidationError.invalidTooLong;
    }
    if (value.length <= 3) return UsernameValidationError.invalidTooShort;
    if (RegExp(r'^[A-Za-z0-9@.+-_]+$').hasMatch(value) == false) {
      return UsernameValidationError.invalidChars;
    }
  }

  @override
  String? get errorMessage {
    if (error == UsernameValidationError.api) return serverError;
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

  @override
  List<Object?> get props => super.props + [serverError];
}
