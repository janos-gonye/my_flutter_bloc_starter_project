import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/views/app_settings_form.dart';
import 'package:my_flutter_bloc_starter_project/theme_selector/theme_selector.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  static get routeName => '/app-settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: const [
                Divider(),
                ThemeSelectorForm(),
                Divider(),
                AppSettingsForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
