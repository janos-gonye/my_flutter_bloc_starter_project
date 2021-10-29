import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_flutter_bloc_starter_project/login/views/login_form.dart';
import 'package:my_flutter_bloc_starter_project/password_reset/views/views.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static get routeName => '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const LoginForm(),
                ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(PasswordResetPage.routeName),
                  child: const Text('Password forgotten?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
