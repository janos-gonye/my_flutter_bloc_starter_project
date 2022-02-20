import 'package:my_flutter_bloc_starter_project/shared/models/base.dart';

enum EmptyPasswordValidationError {
  api,
  empty,
  invalidTooShort,
  invalidMissingRequired,
}

class EmptyPassword extends FormModel<String, EmptyPasswordValidationError> {
  const EmptyPassword(String value, {serverError})
      : super(value, serverError: serverError);

  @override
  EmptyPasswordValidationError? get error {
    if (serverError != null) return EmptyPasswordValidationError.api;
    if (value.isEmpty) return EmptyPasswordValidationError.empty;
  }

  @override
  String? get errorMessage {
    if (error == EmptyPasswordValidationError.api) return serverError;
    if (error == EmptyPasswordValidationError.empty) return 'Empty password';
  }

  @override
  List<Object?> get props => super.props + [serverError];

  @override
  EmptyPassword copyWith({String? value, String? serverError}) {
    return EmptyPassword(
      value ?? this.value,
      serverError: serverError ?? this.serverError,
    );
  }
}
