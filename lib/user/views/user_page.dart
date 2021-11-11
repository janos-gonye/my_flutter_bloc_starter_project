import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_flutter_bloc_starter_project/change_email/views/views.dart';
import 'package:my_flutter_bloc_starter_project/change_password/change_password.dart';
import 'package:my_flutter_bloc_starter_project/remove_account/remove_account.dart';
import 'package:my_flutter_bloc_starter_project/shared/views/app_bars/authenticated_page_app_bar.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  static String get routeName => 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthenticatedPageAppBar(
        title: 'User Page',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Change Password',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const ChangePasswordForm(),
              const SizedBox(height: 30),
              Row(
                children: const [
                  Text(
                    'Change Email',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const ChangeEmailForm(),
              const SizedBox(height: 30),
              const RemoveAccountForm(),
            ],
          ),
        ),
      ),
    );
  }
}
