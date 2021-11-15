import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/profile_settings/views/views.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/helpers.dart'
    as helpers;

class AuthenticatedPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AuthenticatedPageAppBar({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton(
          onSelected: (result) {
            switch (result) {
              case 'to-profile':
                helpers.navigateToWhenNotCurrent(
                    context, ProfileSettings.routeName);
                break;
              case 'sign-out':
                helpers.showSnackbar(context, 'Successfully logged out');
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(LogoutRequested());
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'to-profile',
              child: Text('Profile'),
            ),
            const PopupMenuItem(
              child: PopupMenuDivider(),
            ),
            const PopupMenuItem(
              value: 'sign-out',
              child: Text('Sign out'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
