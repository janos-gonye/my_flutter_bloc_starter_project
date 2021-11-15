import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';

class AppBarLogoutButton extends StatelessWidget {
  const AppBarLogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout_rounded),
      onPressed: () {
        BlocProvider.of<AuthenticationBloc>(context).add(LogoutRequested());
      },
    );
  }
}
