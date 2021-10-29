import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  static String get routeName => 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Text('User Page'),
        ),
      ),
    );
  }
}
