import 'dart:async';

import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/user/user.dart';

class UserRepository {
  UserRepository({required this.dio});

  final Dio dio;

  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = const User('user-id'),
    );
  }
}
