import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum HostnameValidationError { empty, invalid }

class Hostname extends FormzInput<String, HostnameValidationError> {
  const Hostname.pure() : super.pure('');
  const Hostname.dirty([String value = '']) : super.dirty(value);

  @override
  HostnameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return HostnameValidationError.empty;
    } else if (isFQDN(value, {'require_tld': false})) {
      return HostnameValidationError.invalid;
    }
  }

  String? get errorMessage {
    if (error == HostnameValidationError.empty) return 'Empty hostname';
    if (error == HostnameValidationError.invalid) return 'Invalid hostname';
  }
}
