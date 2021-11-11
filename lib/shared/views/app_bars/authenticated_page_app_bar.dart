import 'package:flutter/material.dart';
import 'package:my_flutter_bloc_starter_project/shared/views/buttons/logout_button.dart';

class AuthenticatedPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AuthenticatedPageAppBar({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: const [
        AppBarLogoutButton(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
