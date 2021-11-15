import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/shared/models/base.dart';

enum ProtocolValidationError { empty, invalid }

class Protocol extends FormModel<String, ProtocolValidationError> {
  const Protocol(String value, {serverError})
      : super(value, serverError: serverError);

  @override
  ProtocolValidationError? get error {
    if (value.isEmpty) {
      return ProtocolValidationError.empty;
    } else if (!constants.protocols.contains(value)) {
      return ProtocolValidationError.invalid;
    }
  }

  @override
  String? get errorMessage {
    if (error == ProtocolValidationError.empty) return 'Empty protocol';
    if (error == ProtocolValidationError.invalid) return 'Invalid protocol';
  }

  @override
  Protocol copyWith({String? value, String? serverError}) {
    return Protocol(value ?? this.value,
        serverError: serverError ?? this.serverError);
  }
}
