import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: null,
              child: Text('Navigate to App Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
