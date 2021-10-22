import 'dart:async';

import 'package:my_flutter_bloc_starter_project/user/user.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = const User('user-id'),
    );
  }
}
