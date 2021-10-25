import 'package:my_flutter_bloc_starter_project/shared/models/models.dart';

enum ProtocolValidationError { empty, invalid }

class Protocol extends Model<String, ProtocolValidationError> {
  const Protocol(String value) : super(value);

  @override
  ProtocolValidationError? get error {
    if (value.isEmpty) {
      return ProtocolValidationError.empty;
    } else if (!['http', 'https'].contains(value)) {
      return ProtocolValidationError.invalid;
    }
  }

  @override
  String? get errorMessage {
    if (error == ProtocolValidationError.empty) return 'Empty protocol';
    if (error == ProtocolValidationError.invalid) return 'Invalid protocol';
  }
}
