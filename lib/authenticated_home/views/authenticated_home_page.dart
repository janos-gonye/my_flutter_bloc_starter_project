import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_flutter_bloc_starter_project/shared/views/app_bars/authenticated_page_app_bar.dart';

class AuthenticatedHomePage extends StatelessWidget {
  const AuthenticatedHomePage({Key? key}) : super(key: key);

  static String get routeName => 'authenticated-home';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AuthenticatedPageAppBar(
        title: 'Authenticated Home Page',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Icon(
            Icons.chair,
            size: 280,
          ),
        ),
      ),
    );
  }
}
