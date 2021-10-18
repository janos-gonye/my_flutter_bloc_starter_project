import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  static get routeName => '/app-settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
      ),
      body: const Center(
        child: Text('To be continued'),
      ),
    );
  }
}
