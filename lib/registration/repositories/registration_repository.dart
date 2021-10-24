import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

class RegistrationRepository {
  Future<void> registrate({
    required Username username,
    required Password password,
    required Email email,
  }) async {
    return Future.delayed(const Duration(milliseconds: 300));
  }
}
