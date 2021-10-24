import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  static get routeName => '/registration';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Registration Page'),
      ),
    );
  }
}
