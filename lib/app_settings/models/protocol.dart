import 'package:formz/formz.dart';

enum ProtocolValidationError { empty, invalid }

class Protocol extends FormzInput<String, ProtocolValidationError> {
  const Protocol.pure() : super.pure('');
  const Protocol.dirty([String value = '']) : super.dirty(value);

  @override
  ProtocolValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ProtocolValidationError.empty;
    } else if (!['http', 'https'].contains(value)) {
      return ProtocolValidationError.invalid;
    }
  }

  String? get errorMessage {
    if (error == ProtocolValidationError.empty) return 'Empty protocol';
    if (error == ProtocolValidationError.invalid) return 'Invalid protocol';
  }
}
