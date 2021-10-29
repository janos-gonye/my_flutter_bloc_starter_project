import 'package:string_validator/string_validator.dart';

import 'package:my_flutter_bloc_starter_project/shared/models/base.dart';

enum HostnameValidationError { empty, invalid }

class Hostname extends Model<String, HostnameValidationError> {
  const Hostname(String value) : super(value);

  @override
  HostnameValidationError? get error {
    if (value.isEmpty) {
      return HostnameValidationError.empty;
    }
    if (isFQDN(value, {'require_tld': false}) == false) {
      return HostnameValidationError.invalid;
    }
  }

  @override
  String? get errorMessage {
    if (error == HostnameValidationError.empty) return 'Empty hostname';
    if (error == HostnameValidationError.invalid) return 'Invalid hostname';
  }
}
