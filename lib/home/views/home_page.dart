import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static get routeName => '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppSettingsPage.routeName);
              },
              child: const Text('Navigate to App Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
